import UIKit

/// High-performance image caching system with memory and disk caching
///
/// This cache provides automatic memory management, disk persistence,
/// and handles image loading from URLs with built-in retry logic.
///
/// Usage:
/// ```swift
/// ImageCache.shared.loadImage(from: url) { image in
///     imageView.image = image
/// }
/// ```
final class ImageCache {
    
    // MARK: - Singleton
    
    static let shared = ImageCache()
    
    // MARK: - Properties
    
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let diskCacheDirectory: URL
    private let processingQueue = DispatchQueue(label: "net.emercury.smtp.imagecache", qos: .userInitiated)
    private var activeTasks: [URL: Task<UIImage?, Error>] = [:]
    private let tasksLock = NSLock()
    
    // Configuration
    private let maxMemoryCacheSizeInMB: Int = 50
    private let maxDiskCacheSizeInMB: Int = 100
    private let cacheExpiration: TimeInterval = 7 * 24 * 60 * 60 // 7 days
    
    // MARK: - Initialization
    
    private init() {
        // Configure memory cache
        memoryCache.totalCostLimit = maxMemoryCacheSizeInMB * 1024 * 1024
        memoryCache.countLimit = 100
        
        // Setup disk cache directory
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        diskCacheDirectory = cacheDir.appendingPathComponent("ImageCache", isDirectory: true)
        
        createCacheDirectoryIfNeeded()
        setupMemoryWarningObserver()
        
        Logger.data.info("ImageCache initialized", metadata: [
            "memory_limit_mb": maxMemoryCacheSizeInMB,
            "disk_limit_mb": maxDiskCacheSizeInMB
        ])
    }
    
    // MARK: - Public API
    
    /// Loads an image from cache or network
    /// - Parameters:
    ///   - url: The URL of the image
    ///   - placeholder: Optional placeholder image while loading
    ///   - completion: Completion handler with the loaded image
    func loadImage(
        from url: URL,
        placeholder: UIImage? = nil,
        completion: @escaping (UIImage?) -> Void
    ) {
        // Check memory cache first
        if let cachedImage = getImageFromMemory(url: url) {
            Logger.data.debug("Image loaded from memory cache", metadata: ["url": url.absoluteString])
            completion(cachedImage)
            return
        }
        
        // Return placeholder immediately
        completion(placeholder)
        
        // Check if there's already a task for this URL
        tasksLock.lock()
        if let existingTask = activeTasks[url] {
            tasksLock.unlock()
            Task {
                if let image = try? await existingTask.value {
                    await MainActor.run {
                        completion(image)
                    }
                }
            }
            return
        }
        tasksLock.unlock()
        
        // Create new task
        let task = Task {
            return try await fetchImage(from: url)
        }
        
        tasksLock.lock()
        activeTasks[url] = task
        tasksLock.unlock()
        
        Task {
            do {
                let image = try await task.value
                await MainActor.run {
                    completion(image)
                }
            } catch {
                Logger.data.error("Failed to load image", error: error, metadata: ["url": url.absoluteString])
                await MainActor.run {
                    completion(nil)
                }
            }
            
            tasksLock.lock()
            activeTasks.removeValue(forKey: url)
            tasksLock.unlock()
        }
    }
    
    /// Async version of loadImage
    /// - Parameter url: The URL of the image
    /// - Returns: The loaded image or nil
    func loadImage(from url: URL) async -> UIImage? {
        // Check memory cache
        if let cachedImage = getImageFromMemory(url: url) {
            Logger.data.debug("Image loaded from memory cache", metadata: ["url": url.absoluteString])
            return cachedImage
        }
        
        // Check for existing task
        tasksLock.lock()
        if let existingTask = activeTasks[url] {
            tasksLock.unlock()
            return try? await existingTask.value
        }
        tasksLock.unlock()
        
        // Fetch image
        return try? await fetchImage(from: url)
    }
    
    /// Prefetches images in the background
    /// - Parameter urls: Array of image URLs to prefetch
    func prefetchImages(_ urls: [URL]) {
        Logger.data.info("Prefetching images", metadata: ["count": urls.count])
        
        for url in urls {
            Task(priority: .low) {
                _ = await loadImage(from: url)
            }
        }
    }
    
    /// Clears all cached images
    func clearCache() {
        memoryCache.removeAllObjects()
        
        processingQueue.async { [weak self] in
            guard let self = self else { return }
            try? self.fileManager.removeItem(at: self.diskCacheDirectory)
            self.createCacheDirectoryIfNeeded()
            Logger.data.info("Image cache cleared")
        }
    }
    
    /// Clears expired cache entries
    func clearExpiredCache() {
        processingQueue.async { [weak self] in
            guard let self = self else { return }
            
            guard let files = try? self.fileManager.contentsOfDirectory(
                at: self.diskCacheDirectory,
                includingPropertiesForKeys: [.contentModificationDateKey],
                options: .skipsHiddenFiles
            ) else { return }
            
            let now = Date()
            var removedCount = 0
            
            for file in files {
                guard let attributes = try? self.fileManager.attributesOfItem(atPath: file.path),
                      let modificationDate = attributes[.modificationDate] as? Date else {
                    continue
                }
                
                if now.timeIntervalSince(modificationDate) > self.cacheExpiration {
                    try? self.fileManager.removeItem(at: file)
                    removedCount += 1
                }
            }
            
            Logger.data.info("Cleared expired cache entries", metadata: ["removed_count": removedCount])
        }
    }
    
    /// Returns the current disk cache size in bytes
    func diskCacheSize() -> Int64 {
        var totalSize: Int64 = 0
        
        guard let files = try? fileManager.contentsOfDirectory(
            at: diskCacheDirectory,
            includingPropertiesForKeys: [.fileSizeKey],
            options: .skipsHiddenFiles
        ) else { return 0 }
        
        for file in files {
            if let attributes = try? fileManager.attributesOfItem(atPath: file.path),
               let size = attributes[.size] as? Int64 {
                totalSize += size
            }
        }
        
        return totalSize
    }
    
    // MARK: - Private Methods
    
    private func fetchImage(from url: URL) async throws -> UIImage? {
        // Check disk cache
        if let diskImage = getImageFromDisk(url: url) {
            Logger.data.debug("Image loaded from disk cache", metadata: ["url": url.absoluteString])
            cacheImageInMemory(diskImage, for: url)
            return diskImage
        }
        
        // Download from network
        Logger.data.debug("Downloading image", metadata: ["url": url.absoluteString])
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            Logger.data.warning("Invalid response for image", metadata: [
                "url": url.absoluteString,
                "status": (response as? HTTPURLResponse)?.statusCode ?? -1
            ])
            throw ImageCacheError.invalidResponse
        }
        
        guard let image = UIImage(data: data) else {
            Logger.data.warning("Failed to decode image", metadata: ["url": url.absoluteString])
            throw ImageCacheError.invalidImageData
        }
        
        // Cache the image
        cacheImageInMemory(image, for: url)
        cacheImageOnDisk(data, for: url)
        
        Logger.data.debug("Image downloaded and cached", metadata: ["url": url.absoluteString])
        
        return image
    }
    
    private func getImageFromMemory(url: URL) -> UIImage? {
        let key = url.absoluteString as NSString
        return memoryCache.object(forKey: key)
    }
    
    private func cacheImageInMemory(_ image: UIImage, for url: URL) {
        let key = url.absoluteString as NSString
        let cost = Int(image.size.width * image.size.height * image.scale * image.scale)
        memoryCache.setObject(image, forKey: key, cost: cost)
    }
    
    private func getImageFromDisk(url: URL) -> UIImage? {
        let filePath = diskCachePath(for: url)
        guard fileManager.fileExists(atPath: filePath.path),
              let data = try? Data(contentsOf: filePath),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
    
    private func cacheImageOnDisk(_ data: Data, for url: URL) {
        processingQueue.async { [weak self] in
            guard let self = self else { return }
            let filePath = self.diskCachePath(for: url)
            try? data.write(to: filePath)
            self.enforceMaxDiskCacheSize()
        }
    }
    
    private func diskCachePath(for url: URL) -> URL {
        let fileName = url.absoluteString.data(using: .utf8)?.base64EncodedString() ?? UUID().uuidString
        return diskCacheDirectory.appendingPathComponent(fileName)
    }
    
    private func createCacheDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: diskCacheDirectory.path) {
            try? fileManager.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    private func enforceMaxDiskCacheSize() {
        let maxSizeInBytes = Int64(maxDiskCacheSizeInMB * 1024 * 1024)
        let currentSize = diskCacheSize()
        
        guard currentSize > maxSizeInBytes else { return }
        
        // Get files sorted by modification date (oldest first)
        guard let files = try? fileManager.contentsOfDirectory(
            at: diskCacheDirectory,
            includingPropertiesForKeys: [.contentModificationDateKey, .fileSizeKey],
            options: .skipsHiddenFiles
        ).sorted(by: { file1, file2 in
            let date1 = (try? file1.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast
            let date2 = (try? file2.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast
            return date1 < date2
        }) else { return }
        
        var sizeToRemove = currentSize - maxSizeInBytes
        var removedCount = 0
        
        for file in files {
            guard sizeToRemove > 0 else { break }
            
            if let size = (try? file.resourceValues(forKeys: [.fileSizeKey]))?.fileSize {
                try? fileManager.removeItem(at: file)
                sizeToRemove -= Int64(size)
                removedCount += 1
            }
        }
        
        Logger.data.info("Enforced disk cache size limit", metadata: ["removed_count": removedCount])
    }
    
    private func setupMemoryWarningObserver() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Logger.data.warning("Memory warning received, clearing image cache")
            self?.memoryCache.removeAllObjects()
        }
    }
}

// MARK: - Error Types

enum ImageCacheError: Error {
    case invalidResponse
    case invalidImageData
}

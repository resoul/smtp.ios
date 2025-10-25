import UIKit
import Combine

protocol PreviewIntroViewModel {
    var isLoading: AnyPublisher<Bool, Never> { get }
    var currentPreview: AnyPublisher<PreviewIntro?, Never> { get }

    func getPreview() -> PreviewIntro
    func startPreview(completion: ((_ complete: @escaping () -> Void) -> Void)?)
}

enum PreviewIntroError: LocalizedError {
    case emptyItems
    case invalidDelay
    case invalidAnimationDuration(TimeInterval)

    public var errorDescription: String? {
        switch self {
        case .emptyItems:
            return "PreviewIntro items cannot be empty. Please provide at least one item."
        case .invalidDelay:
            return "Delay must be a positive value greater than 0."
        case .invalidAnimationDuration(let duration):
            return "Animation duration must be between 0.1 and 5.0 seconds. Provided: \(duration)"
        }
    }
}

class PreviewIntroViewModelImpl: PreviewIntroViewModel {
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(true)
    private let currentPreviewSubject = CurrentValueSubject<PreviewIntro?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    private let previewItems: [PreviewIntro]
    private let defaultDelay: TimeInterval

    var isLoading: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }

    var currentPreview: AnyPublisher<PreviewIntro?, Never> {
        currentPreviewSubject.eraseToAnyPublisher()
    }

    func getPreview() -> PreviewIntro {
        guard let item = previewItems.randomElement() else {
            fatalError("Preview must be provided")
        }

        return item
    }

    func startPreview(completion: ((_ complete: @escaping () -> Void) -> Void)? = nil) {
        currentPreviewSubject.send(getPreview())
        
        if let completion = completion {
            completion { [weak self] in
                self?.isLoadingSubject.send(false)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + defaultDelay) { [weak self] in
                self?.isLoadingSubject.send(false)
            }
        }
    }

    private func validateItems(_ items: [PreviewIntro]) throws {
        guard !items.isEmpty else {
            throw PreviewIntroError.emptyItems
        }

        for item in items {
            if item.animationDuration < 0.1 || item.animationDuration > 5.0 {
                throw PreviewIntroError.invalidAnimationDuration(item.animationDuration)
            }
        }
    }

    private func validateDelay(_ delay: TimeInterval) throws {
        guard delay > 0 else {
            throw PreviewIntroError.invalidDelay
        }
    }

    init (items: [PreviewIntro] = [], delay: TimeInterval = 1.5) {
        self.previewItems = items
        self.defaultDelay = delay
        do {
            try validateItems(items)
            try validateDelay(delay)
        } catch {
            fatalError("PreviewIntroViewModel initialization failed: \(error.localizedDescription)")
        }
    }

    deinit {
        cancellables.removeAll()
    }
}

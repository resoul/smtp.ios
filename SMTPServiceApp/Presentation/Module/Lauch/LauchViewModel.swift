import Dispatch

protocol LauchViewModel {
    var isLoading: Observable<Bool> { get }
    var currentSplashItem: Observable<LauchItem?> { get }
    
    func performInitialization()
    func getLauchItem() -> LauchItem
}

final class LauchViewModelImpl: LauchViewModel {
    
    let isLoading = Observable<Bool>(true)
    let currentSplashItem = Observable<LauchItem?>(nil)
    
    private let lauchItems: [LauchItem] = [
        LauchItem(
            title: "Send Messages Based On Website & Email Events",
            image: "splash",
            description: "Unlock the key to super-responsive real-time personalization. Set up customer tracking & custom events today."
        ),
        LauchItem(
            title: "Build Highly-Customizable email Journeys!",
            image: "splash-1",
            description: "Take our drag-and-drop email automation builder, design the ideal customer journey and let our platform convert leads for You On Autopilot."
        )
    ]
    
    func getLauchItem() -> LauchItem {
        return lauchItems.randomElement() ?? lauchItems[0]
    }
    
    func performInitialization() {
        currentSplashItem.value = getLauchItem()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading.value = false
        }
    }
}

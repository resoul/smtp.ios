final class Observable<T> {
    typealias Observer = (T) -> Void
    
    private var observers: [Observer] = []
    
    var value: T {
        didSet {
            notifyObservers()
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ observer: @escaping Observer) {
        observers.append(observer)
        observer(value)
    }
    
    private func notifyObservers() {
        observers.forEach { $0(value) }
    }
}

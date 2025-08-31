import UIKit

final class LauchController: UIViewController {
    private lazy var launchView = LauchView()
    private let viewModel: LauchViewModel
    weak var coordinator: LaunchCoordinator?
    
    init(viewModel: LauchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.currentSplashItem.bind { [weak self] item in
            guard let item = item else { return }
            DispatchQueue.main.async {
                self?.launchView.configure(with: item)
            }
        }
        
        viewModel.isLoading.bind { isLoading in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                if isLoading == false {
                    self?.coordinator?.handleLauchCompletion()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.performInitialization()
    }
    
    override func loadView() {
        view = launchView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

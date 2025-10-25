import UIKit
import Combine

protocol PreviewIntroDelegate: AnyObject {
    func handlePreviewCompletion(isLoading: Bool)
}

final class PreviewIntroController: UIViewController {
    weak var coordinator: PreviewIntroCoordinator?
    private var cancellables = Set<AnyCancellable>()
    weak var delegate: PreviewIntroDelegate?
    private let viewModel: PreviewIntroViewModel
    private let viewNode: PreviewIntroNode

    override func viewDidLoad() {
        super.viewDidLoad()
        viewNode.automaticallyManagesSubnodes = true
        setupView()
        setupBindings()
    }

    private func setupBindings() {
        viewModel.currentPreview
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.viewNode.configure(with: item)
            }
            .store(in: &cancellables)

        viewModel.isLoading
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.delegate?.handlePreviewCompletion(isLoading: isLoading)
            }
            .store(in: &cancellables)
    }

    private func setupView() {
        view = viewNode.view
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startPreview(completion: nil)
    }

    init(viewModel: PreviewIntroViewModel, viewNode: PreviewIntroNode) {
        self.viewModel = viewModel
        self.viewNode = viewNode
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        cancellables.removeAll()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

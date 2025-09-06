import PreviewIntro

protocol ViewModelContainer {
    func makePreviewIntroViewModel() -> PreviewIntroViewModel
    func makeLoginViewModel() -> LoginViewModel
}

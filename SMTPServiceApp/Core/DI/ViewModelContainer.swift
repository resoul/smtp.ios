import PreviewIntro

protocol ViewModelContainer {
    func makePreviewIntroViewModel() -> PreviewIntroViewModel
    func makeRequestResetPasswordViewModel() -> RequestResetPasswordViewModel
    func makeActivateAccountViewModel() -> ActivateAccountViewModel
    func makeForgotPasswordViewModel() -> ForgotPasswordViewModel
    func makeRegistrationViewModel() -> RegistrationViewModel
    func makeLoginViewModel() -> LoginViewModel
}

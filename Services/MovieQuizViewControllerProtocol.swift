protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepModel)
    func show(quiz result: QuizResultsModel)
    func highlightImageBorder(isCorrect: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func stopClickButton(isEnabled: Bool)
}

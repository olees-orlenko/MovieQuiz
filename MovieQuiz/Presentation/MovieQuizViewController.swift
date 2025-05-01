import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol, AlertDelegate {
    
    // MARK: - IB Outlets
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    
    private var alertPresenter: ResultAlertPresenter?
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = ResultAlertPresenter(delegate: self)
        imageView.layer.cornerRadius = 20
        showLoadingIndicator()
        clearBorder()
    }
    
    // MARK: - AlertDelegate
    
    func present(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
        stopClickButton(isEnabled: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
        stopClickButton(isEnabled: false)
    }
    
    // MARK: - Private methods
    
    private func clearBorder(){
        imageView.layer.borderWidth = 0
    }
    
    // MARK: - Public methods
    
    func show(quiz step: QuizStepModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        clearBorder()
    }
    
    func show(quiz result: QuizResultsModel) {
        guard let alertPresenter else { return }
        
        let alert = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: { [weak self] in
                guard let self else { return }
                
                self.presenter.currentQuestionIndex = 0
                self.presenter.correctAnswers = 0
                self.clearBorder()
                self.presenter.restartGame()
            }
        )
        alertPresenter.showAlert(result: alert)
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func stopClickButton(isEnabled: Bool){
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator(){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            message: "Невозможно загрузить данные",
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] in
                guard let self else { return }
                
                self.showLoadingIndicator()
                self.presenter.restartGame()
            }
        )
        alertPresenter?.showAlert(result: alert)
    }
}

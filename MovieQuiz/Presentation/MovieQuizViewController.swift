import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private var imageView: UIImageView!

    // MARK: - Private Properties
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstQuestion = QuizQuestionMock.questions[0]
        let viewModel = convert(model: firstQuestion)
        clearBorder()
        show(quiz: viewModel)
    }
    
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        let newQuestion = QuizQuestionMock.questions[currentQuestionIndex]
        let answer = false
        stopClickButton(isEnabled: false)
        showAnswerResult(isCorrect: answer == newQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let newQuestion = QuizQuestionMock.questions[currentQuestionIndex]
        let answer = true
        stopClickButton(isEnabled: false)
        showAnswerResult(isCorrect: answer == newQuestion.correctAnswer)
    }
    
    // MARK: - Private Methods
    
    private func convert(model: QuizQuestion) -> QuizStepModel {
        return QuizStepModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(QuizQuestionMock.questions.count)")
    }
    
    private func show(quiz step: QuizStepModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        clearBorder()
    }

    private func show(quiz result: QuizResultsModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.clearBorder()
            let firstQuestion = QuizQuestionMock.questions[0]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        if isCorrect {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        stopClickButton(isEnabled: true)
      if currentQuestionIndex == QuizQuestionMock.questions.count - 1 {
          let message = "Ваш результат: \(correctAnswers)/\(QuizQuestionMock.questions.count)"
          let viewModel = QuizResultsModel(
              title: "Этот раунд окончен!",
              text: message,
              buttonText: "Сыграть ещё раз")
          show(quiz: viewModel)
      } else {
          currentQuestionIndex += 1
          let nextQuestion = QuizQuestionMock.questions[currentQuestionIndex]
          let viewModel = convert(model: nextQuestion)
          show(quiz: viewModel)
      }
    }

    private func clearBorder(){
        imageView.layer.borderWidth = 0
    }
    
    private func stopClickButton(isEnabled: Bool){
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }

}

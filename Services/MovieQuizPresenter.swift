import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    var currentQuestionIndex: Int = 0
    weak var viewController: MovieQuizViewController?
    
    func yesButtonClicked() {
        guard let newQuestion = currentQuestion else {
            return
        }
        let answer = true
        viewController?.stopClickButton(isEnabled: false)
        viewController?.showAnswerResult(isCorrect: answer == newQuestion.correctAnswer)
    }
    
    func noButtonClicked() {
        guard let newQuestion = currentQuestion else {
            return
        }
        let answer = false
        viewController?.stopClickButton(isEnabled: false)
        viewController?.showAnswerResult(isCorrect: answer == newQuestion.correctAnswer)
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepModel {
        QuizStepModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
}

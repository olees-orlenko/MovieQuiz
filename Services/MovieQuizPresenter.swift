import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    var statisticService: StatisticServiceProtocol?
    weak var viewController: MovieQuizViewController?
    
    init() {
        statisticService = StatisticService()
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
        viewController?.stopClickButton(isEnabled: true)
        if isLastQuestion() {
            guard let statisticService else { return }
            
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let bestGame = statisticService.bestGame
            let date = bestGame.date.dateTimeString
            let totalAccuracy = statisticService.totalAccuracy
            let gamesCount = statisticService.gamesCount
            let message = """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(gamesCount)
            Рекорд: \(bestGame.correct)/\(bestGame.total) (\(date))
            Средняя точность: \(String(format: "%.2f", totalAccuracy))%
            """
            let viewModel = QuizResultsModel(
                title: "Этот раунд окончен!",
                text: message,
                buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: viewModel)
        } else {
            switchToNextQuestion()
            viewController?.questionFactory?.requestNextQuestion()
        }
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
        viewController?.stopClickButton(isEnabled: false)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
        viewController?.stopClickButton(isEnabled: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let newQuestion = currentQuestion else {
            return
        }
        let answer = isYes
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

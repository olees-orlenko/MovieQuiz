import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    var showLoadingIndicatorTest: Bool = false
    var hideLoadingIndicatorTest: Bool = false
    var stopClickButtonTest: Bool = false
    var highlightImageBorderTest: Bool = false
    
    func stopClickButton(isEnabled: Bool) {
        stopClickButtonTest = true
    }
    
    func show(quiz step: QuizStepModel) {
        
    }
    
    func show(quiz result: QuizResultsModel) {
        
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        highlightImageBorderTest = true
    }
    
    func showLoadingIndicator() {
        showLoadingIndicatorTest = true
    }
    
    func hideLoadingIndicator() {
        hideLoadingIndicatorTest = true
    }
    
    func showNetworkError(message: String) {
        
    }
}

final class QuestionFactoryMock: QuestionFactoryProtocol {
    func loadData() {
    }
    
    func requestNextQuestion() {
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
    
    func testYesButtonClicked() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        sut.currentQuestion = question
        sut.yesButtonClicked()
        XCTAssertEqual(sut.correctAnswers, 1)
        XCTAssertTrue(viewControllerMock.stopClickButtonTest)
        XCTAssertTrue(viewControllerMock.highlightImageBorderTest)
    }
    
    func testNoButtonClicked() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: false)
        sut.currentQuestion = question
        sut.noButtonClicked()
        XCTAssertEqual(sut.correctAnswers, 1)
        XCTAssertTrue(viewControllerMock.stopClickButtonTest)
        XCTAssertTrue(viewControllerMock.highlightImageBorderTest)
    }
    
    func testHideLoadingIndicator() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        let questionFactoryMock = QuestionFactoryMock()
        sut.questionFactory = questionFactoryMock
        sut.didLoadDataFromServer()
        XCTAssertTrue(viewControllerMock.hideLoadingIndicatorTest)
    }
    
    func testShowLoadingIndicator() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        _ = QuestionFactoryMock()
        let _ = MovieQuizPresenter(viewController: viewControllerMock)
        XCTAssertTrue(viewControllerMock.showLoadingIndicatorTest)
    }
}

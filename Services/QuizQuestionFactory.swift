import Foundation

final class QuizQuestionFactory:  QuestionFactoryProtocol {
    // MARK: - Private properties
    
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    private let moviesLoader: MoviesLoading
    
    // MARK: - Initializer
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    // MARK: - Public methods
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async{
                guard let self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        guard !movies.isEmpty else { return }
        let index = Int.random(in: 0..<movies.count)
        let movie = movies[index]
        URLSession.shared.dataTask(with: movie.resizedImageURL) { [weak self] data, _, error in
            guard let self = self else { return }
            guard let imageData = data, error == nil else {
                print("Failed to load image")
                return
            }
            let rating = Float(movie.rating) ?? 0
            let text = "Рейтинг этого фильма больше чем 8?"
            let correctAnswer = rating > 8
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            DispatchQueue.main.async {
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }.resume()
    }
}

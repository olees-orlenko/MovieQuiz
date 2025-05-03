import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    // MARK: - Private properties
    
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    // MARK: - URL
    
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: API.mostPopularMovies) else {
            preconditionFailure("Неверный URL")
        }
        return url
    }
    
    // MARK: - Data Fetching
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) {result in
            switch result{
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(NetworkError.decodingError(message: "Ошибка при обработке данных с сервера")))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}

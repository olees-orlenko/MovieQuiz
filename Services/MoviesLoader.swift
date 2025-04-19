import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    // MARK: - Private properties
    
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: API.mostPopularMovies) else {
            preconditionFailure("Invalid URL")
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
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}

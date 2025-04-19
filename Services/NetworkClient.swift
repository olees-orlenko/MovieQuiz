import Foundation

final class NetworkClient {
    
    private enum NetworkError: Error {
        case codeError
        case invalidStatusCode
    }
    
    // MARK: - Data Fetching
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                handler(.failure(NetworkError.codeError))
                return
            }
            guard (200...299).contains(response.statusCode) else {
                handler(.failure(NetworkError.invalidStatusCode))
                return
            }
            guard let data = data else { return }
            handler(.success(data))
        }
        task.resume()
    }
}

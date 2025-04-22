import Foundation

final class NetworkClient {
    
    // MARK: - Data Fetching
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(NetworkError.codeError(message: error.localizedDescription)))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                handler(.failure(NetworkError.codeError(message: "Некорректный ответ от сервера")))
                return
            }
            guard (200...299).contains(response.statusCode) else {
                handler(.failure(NetworkError.invalidStatusCode(message: "Сервер вернул ошибку: \(response.statusCode)")))
                return
            }
            guard let data = data else {
                handler(.failure(NetworkError.noData(message: "Ошибка загрузки данных с сервера")))
                return
            }
            handler(.success(data))
        }
        task.resume()
    }
}

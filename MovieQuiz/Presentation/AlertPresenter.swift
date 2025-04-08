import UIKit

final class ResultAlertPresenter: AlertProtocol {
    private weak var delegate: AlertDelegate?
    
    init(delegate: AlertDelegate?) {
        self.delegate = delegate
    }
    
    func showAlert(result: AlertModel){
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in result.completion()
        }
        alert.addAction(action)
        delegate?.present(alert: alert)
    }
}

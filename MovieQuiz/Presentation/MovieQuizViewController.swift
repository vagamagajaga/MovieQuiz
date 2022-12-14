import UIKit

final class MovieQuizViewController: UIViewController, MQVCProtocol {
    
    //MARK: - Outlets
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var movieQuestion: UILabel!
    @IBOutlet private weak var movieCount: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    // MARK: - Methods
    func showLoadingIndicator() {
        activityIndicator.isHidden = false 
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        showLoadingIndicator()
        
        let alert: AlertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self  else { return nil }
                return self.presenter.restartGame()
            }
        presenter.alertPresenter?.present(model: alert)
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        movieImage.layer.masksToBounds = true
        movieImage.layer.borderWidth = 8
        movieImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
    }
    
    func showQuestion(quiz step: QuizStepViewModel) {
        guard let currentQuestion = presenter.currentQuestion else { return }
        movieImage.layer.borderColor = UIColor.clear.cgColor
        movieImage.image = presenter.convert(model: currentQuestion).image
        movieQuestion.text = presenter.convert(model: currentQuestion).question
        movieCount.text = presenter.convert(model: currentQuestion).questionNumber
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieImage.layer.cornerRadius = 20
        
        presenter = MovieQuizPresenter(viewController: self)
        
        showLoadingIndicator()
    }
}


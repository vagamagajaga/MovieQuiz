import UIKit

final class MovieQuizViewController: UIViewController, MQVCProtocol {
    //MARK: - Outlets
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var movieQuestion: UILabel!
    @IBOutlet private weak var movieCount: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var noButton: UIButton!
    @IBOutlet var yesButton: UIButton!
    
    // MARK: - Variables
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenterProtocol!
    
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        getTrailerAlert()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieImage.layer.cornerRadius = 20
        self.setButtonsEnabled(true)
        
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(delegate: self)
        
        showLoadingIndicator()
    }
    
    // MARK: - Methods
    func showLoadingIndicator() {
        activityIndicator.isHidden = false 
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = true
        }
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
        alertPresenter?.showAlert(model: alert, isNeedCancel: false)
    }
    
    func presentAlert(model: AlertModel) {
        alertPresenter.showAlert(model: model, isNeedCancel: true)
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        self.setButtonsEnabled(false)
        movieImage.layer.masksToBounds = true
        movieImage.layer.borderWidth = 8
        movieImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showQuestion(quiz step: QuizStepViewModel) {
        guard let currentQuestion = presenter.currentQuestion else { return }
        self.setButtonsEnabled(true)
        movieImage.layer.borderColor = UIColor.clear.cgColor
        movieImage.image = presenter.convert(model: currentQuestion).image
        movieQuestion.text = presenter.convert(model: currentQuestion).question
        movieCount.text = presenter.convert(model: currentQuestion).questionNumber
    }
    
    func setButtonsEnabled(_ enabled: Bool) {
            yesButton.isEnabled = enabled
            noButton.isEnabled = enabled
        }
    
    func getTrailerAlert() {
        guard let alertModel = presenter.getInfoAlertModel() else { return }
        
        alertPresenter?.showAlert(model: alertModel, isNeedCancel: true)
    }
}

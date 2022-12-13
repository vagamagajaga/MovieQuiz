import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    //MARK: - Outlets
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var movieQuestion: UILabel!
    @IBOutlet private weak var movieCount: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    var statisticService: StatisticServiceProtocol = StatisticServiceImplementation()
    var alertPresenter: AlertPresenterProtocol?
    var questionFactory: QuestionFactoryProtocol?
    private let presenter = MovieQuizPresenter()
    
    var correctAnswers: Int = 0

    
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    // MARK: - Methods
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false 
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
        showLoadingIndicator()
        
        let alertModel: AlertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self  else { return nil }
                return self.questionFactory?.loadData() 
            }
        alertPresenter?.present(model: alertModel)
    }
    
    func showAnswerResult(isCorrect: Bool) {
        movieImage.layer.masksToBounds = true
        movieImage.layer.borderWidth = 8
        movieImage.layer.cornerRadius = 20
        movieImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect {
            correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.movieImage.layer.borderWidth = 0
            self.presenter.showNextQuestionOrResults()
        }
    }
    
    func showQuestion(quiz step: QuizStepViewModel) {
        guard let currentQuestion = presenter.currentQuestion else { return }
        movieImage.image = presenter.convert(model: currentQuestion).image
        movieQuestion.text = presenter.convert(model: currentQuestion).question
        movieCount.text = presenter.convert(model: currentQuestion).questionNumber
    }
    


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewController = self
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        self.alertPresenter = AlertPresenter(viewController: self)
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    // MARK: - Movieloader
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
}


import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    //MARK: - Outlets
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var movieQuestion: UILabel!
    @IBOutlet private weak var movieCount: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    private var statisticService: StatisticServiceProtocol = StatisticServiceImplementation()
    private var alertPresenter: AlertPresenterProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private let presenter = MovieQuizPresenter()
    
    private var correctAnswers: Int = 0

    
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
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
            self.showNextQuestionOrResults()
        }
    }
    
    private func showQuestion(quiz step: QuizStepViewModel) {
        guard let currentQuestion = currentQuestion else { return }
        movieImage.image = presenter.convert(model: currentQuestion).image
        movieQuestion.text = presenter.convert(model: currentQuestion).question
        movieCount.text = presenter.convert(model: currentQuestion).questionNumber
    }
    
    private func showNextQuestionOrResults() {
        if presenter.isLastIndex() {
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
            let text = """
Ваш результат: \(correctAnswers) из 10
Количество сыграных квизов: \(statisticService.gamesCount)
Рекорд: \(statisticService.bestGame.correct ) /\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
"""
            let alertModel: AlertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть еще раз") { [weak self] in
                    guard let self = self  else { return nil }
                    self.presenter.resetQuestionIndex()
                    return self.questionFactory?.requestNextQuestion()
                }
            alertPresenter?.present(model: alertModel)
            correctAnswers = 0
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
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
        guard let question = question else {
            return
        }
        currentQuestion = question
        DispatchQueue.main.async { [weak self] in
            //Отличается от варианта из курса из-за отличий в изначально созданном файле
            guard let currentQuestion = self?.currentQuestion, let self = self else { return }
            self.showQuestion(quiz: (self.presenter.convert(model: currentQuestion)))
        }
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


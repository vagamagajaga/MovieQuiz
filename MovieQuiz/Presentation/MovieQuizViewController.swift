import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    //MARK: - Outlets

    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var movieQuestion: UILabel!
    @IBOutlet private weak var movieCount: UILabel!
    
    // MARK: - Variables
    private var statisticService: StatisticServiceProtocol = StatisticServiceImplementation()
    private var alertPresenter: AlertPresenterProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let givenAnswer = false
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let givenAnswer = true
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Methods
    private func showAnswerResult(isCorrect: Bool) {
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
  
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showQuestion(quiz step: QuizStepViewModel) {
        guard let currentQuestion = currentQuestion else { return }
        movieImage.image = convert(model: currentQuestion).image
        movieQuestion.text = convert(model: currentQuestion).question
        movieCount.text = convert(model: currentQuestion).questionNumber
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 6 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let text = """
Ваш результат: \(correctAnswers) из 10
Кличество сыгранных квизов: \(statisticService.gamesCount)
Рекорд: \(statisticService.bestGame.correct ) /\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
"""
            let alertModel: AlertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть еще раз") { [weak self] in
                    guard let self = self  else { return nil }
                    self.currentQuestionIndex = 0
                    return self.questionFactory?.requestNextQuestion()
                }
            
            alertPresenter?.present(model: alertModel)
            correctAnswers = 0
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.alertPresenter = AlertPresenter(viewController: self)
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        
        
//        print(NSHomeDirectory())
//        UserDefaults.standard.set(true, forKey: "viewDidLoad")
//        print(Bundle.main.bundlePath)
//
//        var fileJsonURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let jsonStringfile = "top250MoviesIMDB.json"
//        fileJsonURL.appendPathComponent(jsonStringfile)
//        let jsonString = try! String(contentsOf: fileJsonURL)
//        let data = jsonString.data(using: .utf8)!
//
//        var nedeedCrew: String
//
//        struct Top: Decodable {
//            let items: [Movie]
//        }
//
//        struct Actor: Decodable {
//            let id: String
//            let image: String
//            let name: String
//            let asCharacter: String
//        }
//
//        struct Movie: Decodable {
//          let id: String
//          let rank: String
//          let title: String
//          let fullTitle: String
//          let year: String
//          let image: String
//          let crew: String
//          let imDbRating: String
//          let imDbRatingCount: String
//        }
//
//
//
//        do {
//            let result = try JSONDecoder().decode(Top.self, from: data)
//            nedeedCrew = result.items[0].crew
//            print(nedeedCrew)
//        } catch {
//            print("Failed to parse: \(error.localizedDescription)")
//        }
        
        
    }
    // MARK: - QuestionFactoryDelegate
  
    func didRecieveNextQuestion(question: QuizQuestion?) {
        
        guard let question = question else {
            return
        }
        currentQuestion = question
        DispatchQueue.main.async { [weak self] in
            //Отличается от варианта из курса из-за отличий в изначально созданном файле
            guard let currentQuestion = self?.currentQuestion, let self = self else { return }
            self.showQuestion(quiz: (self.convert(model: currentQuestion)))
        }
    }
}

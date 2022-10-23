import UIKit

final class MovieQuizViewController: UIViewController {
    //MARK: - Outlets

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieQuestion: UILabel!
    @IBOutlet weak var movieCount: UILabel!
    
    // MARK: - Variables
    private var currentQuestionIndex: Int = 0
    private var currentQuestion: QuizQuestion {
        questions[currentQuestionIndex]
    }
    private var correctAnswers: Int = 0
    
    
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    
        
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let givenAnswer = true
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.movieImage.layer.masksToBounds = true
            self.movieImage.layer.borderWidth = 0
            self.movieImage.layer.cornerRadius = 20
            self.showNextQuestionOrResults()
        }
        
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
    private func showQuestion(quiz step: QuizStepViewModel) {
        movieImage.image = convert(model: currentQuestion).image
        movieQuestion.text = convert(model: currentQuestion).question
        movieCount.text = convert(model: currentQuestion).questionNumber
    }

    private func showResult(quiz result: QuizResultsViewModel) {
        
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
       
        let action = UIAlertAction(
            
            title: result.buttonText,
            style: .default,
            handler: { _ in
                
            self.currentQuestionIndex = 0
                
            self.showQuestion(quiz: self.convert(model: self.currentQuestion))
        })
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showNextQuestionOrResults() {
        
      if currentQuestionIndex == questions.count - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
        // показать результат квиза
          let text = "Ваш результат: \(correctAnswers) из 10"
          let resultViewModel: QuizResultsViewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: text,
            buttonText: "Сыграть еще раз")
          showResult(quiz: resultViewModel)
          
      } else {
          
        currentQuestionIndex += 1
        showQuestion(quiz: convert(model: currentQuestion))
          
      }
    }

    // MARK: - Lifecycle

    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        showQuestion(quiz: convert(model: currentQuestion))
        


    }
    
    
    
    
    
    
    
    
    // MARK: - Состояния
    
    // для состояния "Вопрос задан"
    private struct QuizStepViewModel {
      let image: UIImage
      let question: String
      let questionNumber: String
    }

    // для состояния "Результат квиза"
    private struct QuizResultsViewModel {
      let title: String
      let text: String
      let buttonText: String
    }

    // Вопрос
    private struct QuizQuestion {
      let image: String
      let text: String
      let correctAnswer: Bool
    }
    
    // MARK: - Mock-данные
    
    private let questions: [QuizQuestion] = [
                QuizQuestion(
                    image: "The Godfather",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true),
                QuizQuestion(
                    image: "The Dark Knight",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true),
                QuizQuestion(
                    image: "Kill Bill",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true),
                QuizQuestion(
                    image: "The Avengers",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true),
                QuizQuestion(
                    image: "Deadpool",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true),
                QuizQuestion(
                    image: "The Green Knight",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true),
                QuizQuestion(
                    image: "Old",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: false),
                QuizQuestion(
                    image: "The Ice Age Adventures of Buck Wild",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: false),
                QuizQuestion(
                    image: "Tesla",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: false),
                QuizQuestion(
                    image: "Vivarium",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: false)
    ]
}

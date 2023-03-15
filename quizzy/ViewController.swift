import UIKit
import Alamofire
import SwiftyJSON

extension String {
    var htmlDecoded: String {
        guard let data = data(using: .utf8) else { return self }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil).string
        } catch {
            return self
        }
    }
}

class ViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var optionsTableView: UITableView!
    
    
    //MARK: - Public and Static variables
    var questionNumber = 0
    var allOptions: [String] = []
    var questionDataJSON = JSON()
    var correctAnswerIndex = Int()
    var hasMadeSelection = false // not important
    var shouldBeCleared = false // not important
    
    var isResetPressed = false
    
    let questionUrl = "https://opentdb.com/api.php?amount=10&category=18&difficulty=easy&type=multiple"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        getQuestionData()
        
    }
    
    //MARK: - Actions
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        allOptions.removeAll()
        questionNumber += 1
        if questionNumber > 9 {
            print("questionNumber reached the limit")
            return
        }
        updateQuestionData()
        hasMadeSelection = false
        shouldBeCleared = true
    }
    
    
    @IBAction func ResetButtonPressed(_ sender: UIButton) {
        print("ResetButtonPressed")
        allOptions.removeAll()
        questionNumber = 0
        isResetPressed = true
        getQuestionData()
    }
}

//MARK: - Networking
extension ViewController {
    func getQuestionData() {
        AF.request(questionUrl, method: .get).responseJSON { response in
            switch response.result {
            case .success(let safeResult):
                self.questionDataJSON = JSON(safeResult)
                
                if !self.isResetPressed { // not important at the beginning
                    self.updateQuestionData()
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func updateQuestionData() {
        var question: String
        var correctAnswer: String
        
        question = questionDataJSON["results"][questionNumber]["question"].stringValue.htmlDecoded
        correctAnswer = questionDataJSON["results"][questionNumber]["correct_answer"].stringValue.htmlDecoded
        allOptions.append(correctAnswer)
        
        for j in 0...2 {
            let option = questionDataJSON["results"][questionNumber]["incorrect_answers"][j].stringValue.htmlDecoded
            allOptions.append(option)
        }
        
        allOptions.shuffle()
        correctAnswerIndex = allOptions.firstIndex(of: correctAnswer)!
        optionsTableView.reloadData()
        updateUI(with: question)
        
    }
    
    //MARK: - Update UI
    func updateUI(with question: String) {
        questionLabel.text = question
    }
    
}

//MARK: - TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
        return allOptions.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let option = allOptions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell") as! OptionCell
        
        cell.setOption(option: option)
        
        if shouldBeCleared { // not important
            cell.backgroundColor = .white
        }
        print("cellForRowAt") // not important
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // not important
        
        if !hasMadeSelection {
            if correctAnswerIndex == indexPath.row {
                tableView.cellForRow(at: indexPath)?.backgroundColor = .systemGreen
                
            } else {
                tableView.cellForRow(at: indexPath)?.backgroundColor = .systemRed
            }
            hasMadeSelection = true
        }
        print("didSelectRowAt")
    }
    
    
}




import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    
    //MARK: - Public and Static variables
    var questionNumber = 0
    var allOptions: [String] = []
    
    
    //MARK: - Instances
    var questionData = QuestionData()
    
    let questionUrl = "https://opentdb.com/api.php?amount=10&category=18&difficulty=easy&type=multiple"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        getQuestionData()
        
    }
    
    //MARK: - Actions
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        allOptions = []
        
        questionNumber += 1
        if questionNumber > 9 {
            return
        }
        getQuestionData()
    }
}

//MARK: - Networking
extension ViewController {
    func getQuestionData() {
        AF.request(questionUrl, method: .get).responseJSON { response in
            switch response.result {
            case .success(let safeResult):
                let questionData: JSON = JSON(safeResult)
                self.updateQuestionData(json: questionData)
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func updateQuestionData(json: JSON) {
        
        var question: String = ""
        var correctAnswer: String = ""
        
        question = json["results"][questionNumber]["question"].stringValue
        correctAnswer = json["results"][questionNumber]["correct_answer"].stringValue
        allOptions.append(correctAnswer)
        
        for j in 0...2 {
            let option = json["results"][questionNumber]["incorrect_answers"][j].stringValue
            allOptions.append(option)
        }
        
        optionsTableView.reloadData()
        updateUI(question: question)
        
    }

    //MARK: - Update UI
    func updateUI(question: String) {
        questionLabel.text = question
    }
    
}

//MARK: - TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let option = allOptions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell") as! OptionCell
        
        cell.setOption(option: option)
        return cell
    }

}




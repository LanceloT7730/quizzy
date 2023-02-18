//
//  QuestionData.swift
//  quizzy
//
//  Created by Doniyorbek Ibrokhimov  on 18/02/23.
//

import Foundation

struct QuestionData: Codable {
//    results[0].question
//    var myArray = Array(repeating: "", count: 8)
    var results: [Results] = Array(repeating: Results(), count: 10)
    
    
}

struct Results: Codable{
    var question: String = ""
    var correct_answer: String = ""
    var incorrect_answers: [String] = [""]
}


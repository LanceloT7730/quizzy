//
//  OptionCell.swift
//  quizzy
//
//  Created by Doniyorbek Ibrokhimov  on 19/02/23.
//

import UIKit

class OptionCell: UITableViewCell {

    @IBOutlet weak var optionCell: UILabel!
    
    func setOption(option: String) {
        optionCell.text = option
    }
}

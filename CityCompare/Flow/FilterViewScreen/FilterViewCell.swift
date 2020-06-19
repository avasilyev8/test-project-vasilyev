//
//  FilterViewCell.swift
//  CityCompare
//
//  Created by  Mad Brains on 26/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import UIKit

class FilterViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryStateSwitch: UISwitch!
    
    var viewModel: FilterViewCellModel? {
        didSet {
            if let viewModel = viewModel {
                categoryLabel.text = viewModel.title
                categoryStateSwitch.setOn(viewModel.isEnabled, animated: true)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryStateSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        categoryLabel.text = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryLabel.text = nil
    }
    
    @objc func switchChanged(changedSwitch: UISwitch) {
        viewModel?.isEnabled = changedSwitch.isOn
    }

}

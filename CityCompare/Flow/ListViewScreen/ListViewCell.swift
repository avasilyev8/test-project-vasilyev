//
//  ListViewCell.swift
//  CityCompare
//
//  Created by  Mad Brains on 12/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import UIKit
import Kingfisher

class ListViewCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var fullCityNameLabel: UILabel!
    
    var viewModel: ListViewCellModel? {
        didSet {
            cityNameLabel.text = viewModel?.cityShortName
            fullCityNameLabel.text = viewModel?.cityFullName
            if let urlString = viewModel?.imageURL {
                cityImageView.kf.setImage(with: URL(string: urlString))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cityNameLabel.text = nil
        fullCityNameLabel.text = nil
    }
    
    override func prepareForReuse() {
        cityNameLabel.text = nil
        fullCityNameLabel.text = nil
        cityImageView.kf.cancelDownloadTask()
    }
    
}

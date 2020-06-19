//
//  SearchCell.swift
//  CityCompare
//
//  Created by  Mad Brains on 25/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    var viewModel: SearchViewCellModel? {
        didSet {
            nameLabel.text = viewModel?.title
            fullNameLabel.text = viewModel?.cityFullName
            if let urlString = viewModel?.imageURL {
                cityImageView.kf.setImage(with: URL(string: urlString))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = nil
        fullNameLabel.text = nil
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        fullNameLabel.text = nil
        cityImageView.kf.cancelDownloadTask()
    }
    
}

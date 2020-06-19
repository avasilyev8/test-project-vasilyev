//
//  FilterViewCellModel.swift
//  CityCompare
//
//  Created by  Mad Brains on 26/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

class FilterViewCellModel {
    
    let title: String
    var isEnabled: Bool
    
    init(title: String, isEnabled: Bool) {
        self.title = title
        self.isEnabled = isEnabled
    }
    
}

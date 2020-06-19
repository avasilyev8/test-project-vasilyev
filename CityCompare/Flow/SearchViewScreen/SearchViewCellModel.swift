//
//  SearchViewCellModel.swift
//  CityCompare
//
//  Created by  Mad Brains on 01/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

class SearchViewCellModel {
    
    let title: String?
    let geonameID: Int
    let imageURL: String
    let cityFullName: String

    init(title: String?, geonameID: Int, imageURL: String, cityFullName: String) {
        self.title = title
        self.geonameID = geonameID
        self.imageURL = imageURL
        self.cityFullName = cityFullName
    }
    
}

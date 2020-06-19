//
//  ListViewCellModel.swift
//  CityCompare
//
//  Created by  Mad Brains on 12/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

class ListViewCellModel {
    
    let cityFullName: String
    let cityShortName: String
    let geoID: Int
    let imageURL: String
    
    init(cityName: String, geoID: Int, imageURL: String) {
        self.cityFullName = cityName
        let name = cityName.prefix {
            $0 != ","
        }
        cityShortName = String(name)
        self.geoID = geoID
        self.imageURL = imageURL
    }
    
}

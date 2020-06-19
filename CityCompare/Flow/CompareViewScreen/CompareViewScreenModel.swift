//
//  CompareViewScreenModel.swift
//  CityCompare
//
//  Created by  Mad Brains on 15/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

class CompareViewScreenModel {
    
    private(set) var mutableDict: [String: Float]
    private(set) var immutableDict: [String: Float]
    let cityName: String
    let geoID: Int
    
    init(mutableDict: [String: Float], immutableDict: [String: Float], cityName: String, geonameID: Int) {
        self.mutableDict = mutableDict
        self.immutableDict = immutableDict
        self.cityName = cityName
        self.geoID = geonameID
    }
    
    func setScoreDict(newScoreDict: [String: Float]) {
        mutableDict = newScoreDict
    }
    
}

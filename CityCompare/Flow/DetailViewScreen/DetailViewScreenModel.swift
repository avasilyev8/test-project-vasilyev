//
//  DetailViewScreenModel.swift
//  CityCompare
//
//  Created by  Mad Brains on 07/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//
import Foundation

struct DetailViewScreenModel {
    
    enum ImportantCategories: String {
        case housing = "Housing"
        case costOfLiving = "Cost of Living"
        case startups = "Startups"
        case ventureCapital = "Venture Capital"
        case travelConnectivity = "Travel Connectivity"
        case commute = "Commute"
    }
    
    let summary: NSAttributedString
    let cityName: String
    let geonameID: Int
    let scoreInformation: [String: Float]
    let formattedStringForCategory: [ImportantCategories: String]
    let imageURL: String
    
    init(summaryInfo: NSAttributedString, cityName: String, geonameID: Int, scoreInfo: [String: Float], imageURL: String) {
        self.summary = summaryInfo
        self.cityName = cityName
        self.geonameID = geonameID
        self.scoreInformation = scoreInfo
        self.imageURL = imageURL
        formattedStringForCategory = scoreInfo.reduce([:]) { dict, element in
            var mutableDict = dict
            if let someCategory = ImportantCategories(rawValue: element.key) {
                mutableDict[someCategory] = element.key + " " + String(format:"%.1f", element.value)
            }
            return mutableDict
        }
    }
    
}

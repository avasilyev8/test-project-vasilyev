//
//  DetailViewModel.swift
//  CityCompare
//
//  Created by  Mad Brains on 05/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//
//  TODO: - Добавить ProgressHud, заменить лейблы на коллекшнвью

import Foundation
import UIKit

struct DetailViewModelInput {
    
    var realmHelper: RealmHelper
    var queryAPI: QueryAPI
    var geonameID: Int
    var requestedCity: String
    var imageURL: String    
}

protocol DetailViewModelOutput: class {

    func addCityDataToList(_ viewModel: DetailViewModel, someData: DetailViewScreenModel)
    
}

class DetailViewModel: BaseViewModel {
    
    private let input: DetailViewModelInput
    private weak var output: DetailViewModelOutput?
    
    private var queryAPI: QueryAPI {
        return input.queryAPI
    }
    private var realmHelper: RealmHelper {
        return input.realmHelper
    }
    var city: String {
        return input.requestedCity
    }
    var geoID: Int {
        return input.geonameID
    }
    var imageURL: String {
        return input.imageURL
    }
    
    let detailScreenModel = RxProperty<DetailViewScreenModel?>(value: nil)
    
    init(input: DetailViewModelInput, output: DetailViewModelOutput) {
        self.input = input
        self.output = output
        super.init()
        loadScoresForRequestedCity()
    }
    
    func loadScoresForRequestedCity() {
        queryAPI.searchCity(city: city, completionHandler: { [weak self] (response: BaseQueryAPIResponse) in
            self?.createModel(response: response)
        })
    }
    
    private func createModel(response: BaseQueryAPIResponse) {
        let summary = response.embeddedMain?.citySearchResult?.first?.citySearchEmbedded?.cityItemResponse?.cityItemEmbedded?.cityUrbanAreaResponse?.cityUrbanAreaEmbedded?.urbanAreaScoreResponse?.summary ?? ""
        guard let data = summary.data(using: String.Encoding.utf8),
            let summaryInfo = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
                return
        }
        var scoreInfo = [String: Float]()
        if let categories = response.embeddedMain?.citySearchResult?.first?.citySearchEmbedded?.cityItemResponse?.cityItemEmbedded?.cityUrbanAreaResponse?.cityUrbanAreaEmbedded?.urbanAreaScoreResponse?.categories {
            scoreInfo = categories.reduce([String: Float]()) { dict, element in
                var mutableDict = dict
                if let category = element.category, let score = element.score {
                    mutableDict[category] = score
                }
                return mutableDict
            }
            detailScreenModel.set(DetailViewScreenModel(summaryInfo: summaryInfo, cityName: city, geonameID: geoID, scoreInfo: scoreInfo, imageURL: imageURL))
        }
    }

    func saveCityData() {
        guard let someCityData = detailScreenModel.get() else {
            return
        }
        let cityInformation = CityInformation()
        someCityData.scoreInformation.forEach { (key,value) in
            cityInformation.categories.append(key)
            cityInformation.scores.append(value)
        }
        cityInformation.generalInfo = someCityData.summary.string
        cityInformation.name = self.city
        cityInformation.id = self.geoID
        cityInformation.imageURL = self.imageURL
        realmHelper.addNewCity(cityInfo: cityInformation)
    }    
    
    func passCityData() {
        guard let someData = detailScreenModel.get() else {
            return
        }
        output?.addCityDataToList(self, someData: someData)
    }
    
}

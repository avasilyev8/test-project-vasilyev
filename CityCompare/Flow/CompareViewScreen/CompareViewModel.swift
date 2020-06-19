//
//  CompareViewModel.swift
//  CityCompare
//
//  Created by  Mad Brains on 31/01/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//
import Charts

protocol CompareViewModelInput {
    
    var realmHelper: RealmHelper { get }
    var comparisonHelper: ComparisonHelper { get }
    
}

protocol CompareViewModelOutput {
    
    func passDataToFilterCategories(_ viewModel: CompareViewModel, categories: [String: Bool])
    
}

class CompareViewModel: BaseViewModel {
    
    private let input: CompareViewModelInput
    private let output: CompareViewModelOutput
    private var realmHelper: RealmHelper {
        return input.realmHelper
    }
    private var comparisonHelper: ComparisonHelper {
        return input.comparisonHelper
    }
    private var compareScreenModels = [CompareViewScreenModel]()
    let chartData = RxProperty<RadarChartData?>(value: nil)
    private var radarChartCategories = [String]()
    private var filteredCategories = [String]()
    private var categoriesToPass = [String: Bool]()
    private(set) var filteredDict = [String: Float]()
 
    init(input: CompareViewModelInput, output: CompareViewModelOutput) {
        self.input = input
        self.output = output
        super.init()
    }
    
    func loadLocationData(id: Int) {
        let loadedCity = realmHelper.loadSpecificCity(id)
        let scores = Array(loadedCity.scores)
        let cityName = loadedCity.name
        let geoID = loadedCity.id
        if radarChartCategories.isEmpty {
            radarChartCategories = Array(loadedCity.categories)
            filteredCategories = radarChartCategories
            radarChartCategories.forEach {
                categoriesToPass[$0] = true
            }
        }
        let initialDict = Dictionary(uniqueKeysWithValues: zip(radarChartCategories,scores))
        filteredDict = initialDict.filter {
            filteredCategories.contains($0.key)
        }
        if compareScreenModels.count <= 1 {
            compareScreenModels.append(CompareViewScreenModel(mutableDict: filteredDict, immutableDict: initialDict, cityName: cityName, geonameID: geoID))
        }
        comparisonHelper.updateCount(with: compareScreenModels.count)
        let updatedChartData = createChartData(with: compareScreenModels)
        chartData.set(updatedChartData)
    }
    
    func deleteLocationData(id: Int) {
        compareScreenModels.removeAll() {
            $0.geoID == id
        }
        comparisonHelper.updateCount(with: compareScreenModels.count)
        let updatedChartData = createChartData(with: compareScreenModels)
        chartData.set(updatedChartData)
    }
    
    private func createChartData(with models: [CompareViewScreenModel]) -> RadarChartData? {
        let sets: [RadarChartDataSet] = models.map {
            let entry = $0.mutableDict.values.map {
                RadarChartDataEntry(value: Double($0))
            }
            let set = RadarChartDataSet(values: entry, label: $0.cityName)
            set.drawFilledEnabled = true
            set.fillAlpha = 0.7
            set.lineWidth = 2
            set.drawHighlightCircleEnabled = true
            set.setDrawHighlightIndicators(false)
            return set
        }
        if !sets.isEmpty {
            sets[0].setColor(UIColor(red: 103/255, green: 110/255, blue: 129/255, alpha: 1))
            sets[0].fillColor = UIColor(red: 103/255, green: 110/255, blue: 129/255, alpha: 1)
        } else {
            return nil
        }
        if sets.count == 2 {
            sets[1].setColor(UIColor(red: 121/255, green: 162/255, blue: 175/255, alpha: 1))
            sets[1].fillColor = UIColor(red: 121/255, green: 162/255, blue: 175/255, alpha: 1)
        }
        let data = RadarChartData(dataSets: sets)
        data.setValueFont(.systemFont(ofSize: 9, weight: .light))
        data.setDrawValues(false)
        data.setValueTextColor(.black)
        return data
    }
    
    func filterCategories() {
        output.passDataToFilterCategories(self, categories: categoriesToPass)
    }
    
    func setChartCategories(with categories: [String: Bool]) {
        categoriesToPass = categories
        filteredCategories = Array(categories.filter {
            $0.value == true
        }.keys)
        compareScreenModels.forEach {
            let dictToFilter = $0.immutableDict
            filteredDict = dictToFilter.filter {
                filteredCategories.contains($0.key)
            }
            $0.setScoreDict(newScoreDict: filteredDict)
        }
        chartData.set(createChartData(with: compareScreenModels))
    }
    
    func checkScreenAvailability() -> Bool {
        return comparisonHelper.checkZeroCount()
    }
    
}

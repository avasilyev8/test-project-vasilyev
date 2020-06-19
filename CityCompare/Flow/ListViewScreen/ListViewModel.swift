//
//  ListViewModel.swift
//  CityCompare
//
//  Created by  Mad Brains on 31/01/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//
import Foundation

protocol ListViewModelInput {
    
    var realmHelper: RealmHelper { get }
    var comparisonHelper: ComparisonHelper { get }
}

protocol ListViewModelOutput: class {
    
    func addCityToComparison(_ viewModel: ListViewModel, cellViewModel: ListViewCellModel)
    func removeCityFromComparison(_ viewModel: ListViewModel, id: Int)
    
}

class ListViewModel: BaseViewModel {
    
    private let input: ListViewModelInput
    private weak var output: ListViewModelOutput?
    private var realmHelper: RealmHelper {
        return input.realmHelper
    }
    private var comparisonHelper: ComparisonHelper {
        return input.comparisonHelper
    }
    
    let listViewCellModels = RxProperty<[ListViewCellModel]>(value: [])
    
    init(input: ListViewModelInput, output: ListViewModelOutput) {
        self.input = input
        self.output = output
        super.init()
        self.loadLocalDataAboutCities()
    }
    
    func loadLocalDataAboutCities() {
        let loadedCities = realmHelper.loadCities()
        let cellModels: [ListViewCellModel] = loadedCities.map {
            
            return ListViewCellModel(cityName: $0.name, geoID: $0.id, imageURL: $0.imageURL)
        }
        listViewCellModels.set(cellModels)
    }
    
    func loadLocalDataAboutSpecificCity(cityName: String, id: Int, imageURL: String) {
        var listCellModels = listViewCellModels.get()
        listCellModels.append(ListViewCellModel(cityName: cityName, geoID: id, imageURL: imageURL))
        listViewCellModels.set(listCellModels)
    }
    
    public func getCellViewModel(at indexPath: IndexPath) -> ListViewCellModel? {
        return listViewCellModels.get()[indexPath.row]
    }
    
    func removeData(at index: IndexPath) {
        var listCellModels = listViewCellModels.get()
        let geonameID = listCellModels[index.row].geoID
        realmHelper.deleteCityFromDB(geonameID)
        output?.removeCityFromComparison(self, id: geonameID)
        
        listCellModels.remove(at: index.row)
        let updatedCellModels = listCellModels
        listViewCellModels.set(updatedCellModels)
    }
    
    func addChoosenCityToComparisonScreen(listViewCellModel: ListViewCellModel) {
        output?.addCityToComparison(self, cellViewModel: listViewCellModel)
    }
    
    func checkButtonAvailability() -> Bool {
        return comparisonHelper.checkCount()
    }
    
}

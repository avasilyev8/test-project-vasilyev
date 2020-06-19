//
//  FilterViewModel.swift
//  CityCompare
//
//  Created by  Mad Brains on 26/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import Foundation

protocol FilterViewModelOutput {
    
    func sendFilteredCategories(_ viewModel: FilterViewModel, filteredCategories: [String: Bool])
    
}

class FilterViewModel: BaseViewModel {
    
    private let output: FilterViewModelOutput
    private var categories: [String: Bool]
    
    let filterViewCellModels = RxProperty<[FilterViewCellModel]>(value: [])
    
    init(categories: [String: Bool], output: FilterViewModelOutput) {
        self.categories = categories
        self.output = output
        super.init()
        loadCategories()
    }
    
    func loadCategories() {
        let cellModels: [FilterViewCellModel] = categories.map {
            return FilterViewCellModel(title: $0.key, isEnabled: $0.value)
        }
        filterViewCellModels.set(cellModels)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> FilterViewCellModel? {
        return filterViewCellModels.get()[indexPath.row]
    }
    
    func sendCategoriesBack() {
        let cellModels = filterViewCellModels.get()
        var categories = [String: Bool]()
        cellModels.forEach {
            categories[$0.title] = $0.isEnabled
        }
        output.sendFilteredCategories(self, filteredCategories: categories)
    }
    
}

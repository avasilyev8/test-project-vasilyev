//
//  SearchFlowCoordinator.swift
//  CityCompare
//
//  Created by  Mad Brains on 30/01/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

struct CompareFlowCoordinatorInput {
    
    let router: Router
    let realmHelper: RealmHelper
    let comparisonHelper: ComparisonHelper
    
}

class CompareFlowCoordinator: BaseCoordinator {
    
    private let input: CompareFlowCoordinatorInput
    private var vc: CompareViewController!
    private var vm: CompareViewModel!
    
    init(input: CompareFlowCoordinatorInput) {
        self.input = input
    }
    
    override func start() {
        vm = CompareViewModel(input: self, output: self)
        vc = CompareViewController(viewModel: vm)
        router.installRootModule(vc, hideBar: true)        
    }
    
    func addLocationToComparison(viewModel: ListViewCellModel) {
        vm.loadLocationData(id: viewModel.geoID)
    }
    
    func removerLocationFromComparison(id: Int) {
        vm.deleteLocationData(id: id)
    }
    
}

extension CompareFlowCoordinator: CompareViewModelInput {
    
    var realmHelper: RealmHelper {
        return input.realmHelper
    }
    var router: Router {
        return input.router
    }
    var comparisonHelper: ComparisonHelper {
        return input.comparisonHelper
    }
    
}

extension CompareFlowCoordinator: CompareViewModelOutput {
    
    func passDataToFilterCategories(_ viewModel: CompareViewModel, categories: [String: Bool]) {
        let vm = FilterViewModel(categories: categories, output: self)
        let vc = FilterViewController(viewModel: vm)
        router.push(vc)
    }
    
}

extension CompareFlowCoordinator: FilterViewModelOutput {
    
    func sendFilteredCategories(_ viewModel: FilterViewModel, filteredCategories: [String: Bool]) {
        vm.setChartCategories(with: filteredCategories)
    }
    
}

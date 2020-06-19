//
//  ListFlowCoordinator.swift
//  CityCompare
//
//  Created by  Mad Brains on 31/01/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

struct ListFlowCoordinatorInput {
    
    let router: Router
    let realmHelper: RealmHelper
    let comparisonHelper: ComparisonHelper
    
}

protocol ListFlowCoordinatorOutput: class {
    
    func didAddLocationToComparison(_ coordinator: ListFlowCoordinator, cellViewModel: ListViewCellModel)
    
    func didRemoveLocationFromComparison(_ coordinator: ListFlowCoordinator, id: Int)    
}

class ListFlowCoordinator: BaseCoordinator {
    
    private let input: ListFlowCoordinatorInput
    private weak var output: ListFlowCoordinatorOutput?
    private var listViewModel: ListViewModel!
    
    init(input: ListFlowCoordinatorInput, output: ListFlowCoordinatorOutput) {
        self.input = input
        self.output = output        
    }
    
    override func start() {
        listViewModel = ListViewModel(input: self, output: self)
        let vc = ListViewController(viewModel: listViewModel)
        router.installRootModule(vc, hideBar: false)
    }
    
    func addLocationToList(cityInfo: DetailViewScreenModel) {
        listViewModel.loadLocalDataAboutSpecificCity(cityName: cityInfo.cityName, id: cityInfo.geonameID, imageURL: cityInfo.imageURL)
    }
    
}

extension ListFlowCoordinator: ListViewModelInput {
    
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

extension ListFlowCoordinator: ListViewModelOutput {

    func removeCityFromComparison(_ viewModel: ListViewModel, id: Int) {
        output?.didRemoveLocationFromComparison(self, id: id)
    }
    
    func addCityToComparison(_ viewModel: ListViewModel, cellViewModel: ListViewCellModel) {
        output?.didAddLocationToComparison(self, cellViewModel: cellViewModel)
    }
    
}

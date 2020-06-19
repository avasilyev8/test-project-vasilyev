//
//  SearchFlowCoordinator.swift
//  CityCompare
//
//  Created by  Mad Brains on 30/01/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

struct SearchFlowCoordinatorInput {
    
    let router: Router
    let queryAPI: QueryAPI
    let realmHelper: RealmHelper
    
}

protocol SearchFlowCoordinatorOutput: class {    

    func didAddLocationToList(_ coordinator: SearchFlowCoordinator, detailScreenModel: DetailViewScreenModel)
    
}

class SearchFlowCoordinator: BaseCoordinator {
    
    private let input: SearchFlowCoordinatorInput
    private weak var output: SearchFlowCoordinatorOutput?
    private var realmHelper: RealmHelper {
        return input.realmHelper
    }
    private var router: Router {
        return input.router
    }
    private var queryAPI: QueryAPI {
        return input.queryAPI
    }
   
    init(input: SearchFlowCoordinatorInput, output: SearchFlowCoordinatorOutput) {
        self.input = input
        self.output = output
    }
    
    override func start() {
        let vm = SearchViewModel(queryAPI: queryAPI, output: self)
        let vc = SearchViewController(viewModel: vm)
        router.installRootModule(vc, hideBar: false)
    }
    
}

extension SearchFlowCoordinator: SearchViewModelOutput {
    
    func onCityTap(_ viewModel: SearchViewModel, detailCellModel: SearchViewCellModel) {
        openDetailScreen(viewModel, cityName: detailCellModel.cityFullName, geonameID: detailCellModel.geonameID, imageURL: detailCellModel.imageURL)
    }
    
    func openDetailScreen(_ viewModel: SearchViewModel, cityName: String, geonameID: Int, imageURL: String) {
        let input = DetailViewModelInput(realmHelper: realmHelper, queryAPI: queryAPI, geonameID: geonameID, requestedCity: cityName, imageURL: imageURL)
        let vm = DetailViewModel(input: input, output: self)
        let vc = DetailViewController(viewModel: vm)
        router.push(vc)
    }
    
}

extension SearchFlowCoordinator: DetailViewModelOutput {
    
    func addCityDataToList(_ viewModel: DetailViewModel, someData: DetailViewScreenModel) {
        output?.didAddLocationToList(self, detailScreenModel: someData)
    }
    
}

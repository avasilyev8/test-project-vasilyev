//
//  SearchViewModel.swift
//  CityCompare
//
//  Created by  Mad Brains on 31/01/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation
import ObjectMapper

protocol SearchViewModelOutput: class {
    
    func onCityTap(_ viewModel: SearchViewModel, detailCellModel: SearchViewCellModel)
}

protocol SearchViewModelDelegate: class {
    
    func searchViewModel(_ searchViewModel: SearchViewModel, didFailFetchingWithError: String)
    func searchViewModel(_ searchViewModel: SearchViewModel, didFailMappingWithError: String)
    func searchViewModel(startLoading searchViewModel: SearchViewModel)
    func searchViewModel(endLoading searchViewModel: SearchViewModel)
    
}

class SearchViewModel: BaseViewModel {
    
    private weak var output: SearchViewModelOutput?
    private let queryAPI: QueryAPI
    
    weak var delegate: SearchViewModelDelegate?
    let cellViewModels = RxProperty<[SearchViewCellModel]>(value: [])
    
    init(queryAPI: QueryAPI, output: SearchViewModelOutput) {
        self.queryAPI = queryAPI
        self.output = output
    }
    
    func fetchCityList(text cityName: String?) {
        delegate?.searchViewModel(startLoading: self)
        let parameters = ["embed":"city:search-results/city:item/city:urban_area/ua:images"]
        if let city = cityName, !city.isEmpty {
            queryAPI.searchCity(city: city, parameters: parameters, completionHandler: { [weak self] (response: BaseQueryAPIResponse) in
                self?.createCellModel(response: response)
                }, errorHandler: { [weak self] _ in
                    self?.handleFetchError()
            })
        }
    }

    func createCellModel(response: BaseQueryAPIResponse) {
        guard let searchResults = response.embeddedMain?.citySearchResult, !searchResults.isEmpty else {
            delegate?.searchViewModel(self, didFailMappingWithError: "Could not find this city")
            return
        }
        let result: [SearchViewCellModel] = searchResults.compactMap {
            guard let cityItem = $0.citySearchEmbedded?.cityItemResponse,
            let geonameID = cityItem.geonameID,
            let shortName = cityItem.shortName,
            let fullName = cityItem.fullName,
            let imageURL = $0.citySearchEmbedded?.cityItemResponse?.cityItemEmbedded?.cityUrbanAreaResponse?.cityUrbanAreaEmbedded?.urbanAreaImageResponse?.photos?.first?.image else {
                return nil
            }
            return SearchViewCellModel(title: shortName, geonameID: geonameID, imageURL: imageURL, cityFullName: fullName)
        }
        if result.isEmpty {
            delegate?.searchViewModel(self, didFailMappingWithError: "Could not find this city")
        }
        delegate?.searchViewModel(endLoading: self)
        cellViewModels.set(result)
    }
    
    func didSelect(detailCellModel vm: SearchViewCellModel) {
        output?.onCityTap(self, detailCellModel: vm)
    }
    
    func handleFetchError() {
        cellViewModels.set([])
        delegate?.searchViewModel(self, didFailFetchingWithError: "Something wrong occured. Please try again!")
        delegate?.searchViewModel(endLoading: self)
    }
    
    func cellViewModel(at indexPath: IndexPath) -> SearchViewCellModel? {
        return cellViewModels.get()[indexPath.row]
    }
    
}

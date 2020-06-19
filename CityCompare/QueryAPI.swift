//
//  QueryAPI.swift
//  CityCompare
//
//  Created by  Mad Brains on 01/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import RxCocoa
import RxSwift

class QueryAPI {
    
    private let searchURL = "https://api.teleport.org/api/cities/?search="
    private let parameters = "&embed=city%3Asearch-results%2Fcity%3Aitem%2Fcity%3Aurban_area%2Fua%3Aimages"
    private let sessionManager = SessionManager()
    private let defaultHeader = ["Content-Type": "application/vnd.teleport.v1+json"]
    private let defaultParameters = ["embed":"city:search-results/city:item/city:urban_area/ua:scores"]

    
    func searchCity<T: Mappable>(city requestedCity: String, header: [String: String]? = nil, parameters: [String: String]? = nil, completionHandler: ((T) -> Void)? = nil, errorHandler: ((Error) -> Void)? = nil) {
        var neededHeader = defaultHeader
        if let userDefinedHeader = header {
            neededHeader = userDefinedHeader
        }
        var neededParameters = defaultParameters
        if let userDefinedParameters = parameters {
            neededParameters = userDefinedParameters
        }
        var reqCity = requestedCity.replacingOccurrences(of: " ", with: "%20")
        reqCity = String(reqCity.prefix {
            $0 != ","
        })
        
        sessionManager.request(searchURL+reqCity, parameters: neededParameters, headers: neededHeader).responseObject { (response: DataResponse<T>) in
            if let error = response.error {
                errorHandler?(error)
            } else if let requestedValue = response.result.value {
                completionHandler?(requestedValue)
            } else {
                print("Achtung! Unknown error")
            }
        }
    }
    
}

//
//  QueryAPIDataModel.swift
//  CityCompare
//
//  Created by  Mad Brains on 01/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import ObjectMapper

class BaseQueryAPIResponse: Mappable {
    
    var embeddedMain: EmbeddedMain?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        embeddedMain <- map["_embedded"]
    }
    
}

class EmbeddedMain: Mappable {
    
    var citySearchResult: [CitySearchResponse]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        citySearchResult <- map["city:search-results"]
    }
    
}

class CitySearchResponse: Mappable {
    
    var citySearchEmbedded: CitySearchEmbedResponse?
    var name: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        citySearchEmbedded <- map["_embedded"]
        name <- map["matching_full_name"]
    }
    
}

class CitySearchEmbedResponse: Mappable {
    
    var cityItemResponse: CityItemResponse?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        cityItemResponse <- map["city:item"]
    }
    
}

class CityItemResponse: Mappable {
    
    var cityItemEmbedded: CityItemEmbeddedResponse?
    var geonameID: Int?
    var fullName: String?
    var shortName: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        cityItemEmbedded <- map["_embedded"]
        geonameID <- map["geoname_id"]
        fullName <- map["full_name"]
        shortName <- map["name"]
    }
    
}

class CityItemEmbeddedResponse: Mappable {
    
    var cityUrbanAreaResponse: CityUrbanAreaResponse?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        cityUrbanAreaResponse <- map["city:urban_area"]
    }
    
}

class CityUrbanAreaResponse: Mappable {
    
    var cityUrbanAreaEmbedded: CityUrbanAreaEmbedded?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        cityUrbanAreaEmbedded <- map["_embedded"]
    }
    
}

class CityUrbanAreaEmbedded: Mappable {
    
    var urbanAreaScoreResponse: UrbanAreaScoreResponse?
    var urbanAreaImageResponse: UrbanAreaImageResponse?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        urbanAreaScoreResponse <- map["ua:scores"]
        urbanAreaImageResponse <- map["ua:images"]
    }
    
}

class UrbanAreaImageResponse: Mappable {
    
    var photos: [PhotoResponse]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        photos <- map["photos"]
    }
    
}

class PhotoResponse: Mappable {
    
    var image: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        image <- map["image.mobile"]
    }
    
}

class UrbanAreaScoreResponse: Mappable {
    
    var categories: [DetailScoreData]?
    var summary: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        categories <- map["categories"]
        summary <- map["summary"]
    }
    
}

class DetailScoreData: Mappable {
    
    var category: String?
    var score: Float?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        category <- map["name"]
        score <- map["score_out_of_10"]
    }
    
}

//
//  RealmHelper.swift
//  CityCompare
//
//  Created by  Mad Brains on 12/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    
    private let realmDefault = try! Realm()
    
    public func addNewCity(cityInfo: CityInformation) {
        try! realmDefault.write {
            realmDefault.add(cityInfo, update: true)
        }
    }
    
    public func loadCities() -> [CityInformation] {
        return Array(realmDefault.objects(CityInformation.self))
    }
    
    public func loadSpecificCity(_ geonameID: Int) -> CityInformation {
        let predicate = NSPredicate(format: "id == %d", geonameID)
        let cityData = realmDefault.objects(CityInformation.self).filter(predicate)[0]
        return cityData
    }
    
    public func deleteCityFromDB(_ geonameID: Int) {
        let predicate = NSPredicate(format: "id == %d", geonameID)
        if let cityToDelete = realmDefault.objects(CityInformation.self).filter(predicate).first {
            try! realmDefault.write {
                realmDefault.delete(cityToDelete)
            }
        }
    }

}

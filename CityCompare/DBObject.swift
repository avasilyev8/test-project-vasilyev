//
//  DBObject.swift
//  CityCompare
//
//  Created by  Mad Brains on 11/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import RealmSwift

class CityInformation: Object {
    
    @objc dynamic var generalInfo = ""
    @objc dynamic var name = ""
    @objc dynamic var id = 0
    @objc dynamic var imageURL = ""
    let categories = List<String>()
    let scores = List<Float>()
    
    override class func primaryKey() -> String {
        return "id"
    }
    
}

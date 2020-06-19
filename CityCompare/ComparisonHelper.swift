//
//  ComparisonHelper.swift
//  CityCompare
//
//  Created by  Mad Brains on 28/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

class ComparisonHelper {
    
    private var counter = 0
    
    func checkCount() -> Bool {
        return counter < 2
    }
    
    func updateCount(with value: Int) {
        counter = value
    }
    
    func checkZeroCount() -> Bool {
        return counter != 0
    }
    
}

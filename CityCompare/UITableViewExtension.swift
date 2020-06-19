//
//  UITableViewExtension.swift
//  CityCompare
//
//  Created by  Mad Brains on 08/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerNib(forClass neededClass: AnyClass) {
        register(UINib(nibName: String(describing: neededClass), bundle: Bundle.main), forCellReuseIdentifier: String(describing: neededClass))
    }
    
    func dequeueReusableCell<T: UITableViewCell> (forClass neededClass: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: neededClass), for: indexPath) as! T
    }
    
}

//
//  PresentableProtocol.swift
//  Store
//
//  Created by Antol Peshkov on 05/06/2018.
//  Copyright © 2018 madbrains. All rights reserved.
//

import UIKit

protocol Presentable {
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    func toPresent() -> UIViewController? {
        return self
    }
}

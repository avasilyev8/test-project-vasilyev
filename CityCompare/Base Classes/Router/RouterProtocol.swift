//
//  Router.swift
//  Store
//
//  Created by Antol Peshkov on 04/06/2018.
//  Copyright © 2018 madbrains. All rights reserved.
//

import UIKit

protocol Router: Presentable {
    
    func present(_ module: Presentable?)
    func present(_ module: Presentable?, animated: Bool)
    
    func push(_ module: Presentable?)
    func push(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)
    
    func popModule()
    func popModule(animated: Bool)
    
    func dismissModule()
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    
    func installRootModule(_ module: Presentable?)
    func installRootModule(_ module: Presentable?, hideBar: Bool)
    
    func popToRootModule(animated: Bool)
    
    func applyReplaceStack(animated: Bool, transformingClosure: ([UIViewController]) -> ([UIViewController])) -> Bool
    
}

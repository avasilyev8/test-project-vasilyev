//
//  AppCoordinator.swift
//  CityCompare
//
//  Created by  Mad Brains on 30/01/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import Foundation
import UIKit

final class Appcoordinator: BaseCoordinator {
    
    private weak var window: UIWindow?
    private let router: Router
    private let queryAPI: QueryAPI
    private let realmHelper: RealmHelper
    private let comparisonHelper: ComparisonHelper
    
    init(window: UIWindow) {
        self.window = window
        let navigationViewController = UINavigationController()
        window.rootViewController = navigationViewController
        router = DefaultRouter (rootController: navigationViewController)
        queryAPI = QueryAPI()
        realmHelper = RealmHelper()
        comparisonHelper = ComparisonHelper()
        super.init()
    }
    
    override func start() {
        runTabBarFlow()
    }
    
    private func runTabBarFlow() {
        let coordinator = TabBarCoordinator(router: router, queryAPI: queryAPI, realmHelper: realmHelper, comparisonHelper: comparisonHelper)
        addChildCoordinator(coordinator)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.removeChildCoordinator(coordinator)
            self?.router.dismissModule()
        }
        coordinator.start()
    }
    
}

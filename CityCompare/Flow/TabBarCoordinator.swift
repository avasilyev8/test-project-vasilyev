//
//  TabBarCoordinator.swift
//  CityCompare
//
//  Created by  Mad Brains on 30/01/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import UIKit

class TabBarCoordinator : BaseCoordinator {
    
    let tabBarViewController: TabBarViewController
    var finishFlow: (() -> Void)?
    
    private let router: Router
    private let queryAPI: QueryAPI
    private let realmHelper: RealmHelper
    private let comparisonHelper: ComparisonHelper
    
    private var searchNavigationController:UINavigationController!
    private var listNavigationController: UINavigationController!
    private var compareNavigationController: UINavigationController!
    
    private var listFlowCoordinator: ListFlowCoordinator?
    private var compareFlowCoordinator: CompareFlowCoordinator?
    
    init(router: Router, queryAPI: QueryAPI, realmHelper: RealmHelper, comparisonHelper: ComparisonHelper) {
        tabBarViewController = TabBarViewController()
        self.router = router
        self.queryAPI = queryAPI
        self.realmHelper = realmHelper
        self.comparisonHelper = comparisonHelper
    }

    override func start() {
        router.installRootModule(tabBarViewController, hideBar: true)
        tabBarViewController.viewControllers = []
        runFlow()
    }
    
    func runFlow() {
        runSearchFlow()
        runListFlow()
        runCompareFlow()
    }
    
    func runSearchFlow() {
        searchNavigationController = UINavigationController()
        tabBarViewController.addChild(searchNavigationController)
        searchNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let searchRouter = DefaultRouter(rootController: searchNavigationController)
        let input = SearchFlowCoordinatorInput(router: searchRouter, queryAPI: queryAPI, realmHelper: realmHelper)
        let searchCoordinator = SearchFlowCoordinator(input: input, output: self)
        searchCoordinator.start()
        
        self.addChildCoordinator(searchCoordinator)
    }
    
    func runListFlow() {
        listNavigationController = UINavigationController()
        tabBarViewController.addChild(listNavigationController)
        listNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        let listRouter = DefaultRouter (rootController: listNavigationController)
        let input = ListFlowCoordinatorInput(router: listRouter, realmHelper: realmHelper, comparisonHelper: comparisonHelper)
        let listCoordinator = ListFlowCoordinator(input: input, output: self)
        self.listFlowCoordinator = listCoordinator
        listCoordinator.start()
        
        self.addChildCoordinator(listCoordinator)
    }
    
    func runCompareFlow() {
        compareNavigationController = UINavigationController()
        tabBarViewController.addChild(compareNavigationController)
        compareNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 2)
        let compareRouter = DefaultRouter(rootController: compareNavigationController)
        let input = CompareFlowCoordinatorInput(router: compareRouter, realmHelper: realmHelper, comparisonHelper: comparisonHelper)
        let compareCoordinator = CompareFlowCoordinator(input: input)
        self.compareFlowCoordinator = compareCoordinator
        
        compareCoordinator.start()
        self.addChildCoordinator(compareCoordinator)       
    }
    
}

extension TabBarCoordinator: SearchFlowCoordinatorOutput {
    
    func didAddLocationToList(_ coordinator: SearchFlowCoordinator, detailScreenModel: DetailViewScreenModel) {
        listFlowCoordinator?.addLocationToList(cityInfo: detailScreenModel)
    }
    
}

extension TabBarCoordinator: ListFlowCoordinatorOutput {
    
    func didRemoveLocationFromComparison(_ coordinator: ListFlowCoordinator, id: Int) {
        compareFlowCoordinator?.removerLocationFromComparison (id: id)
    }
    
    func didAddLocationToComparison(_ coordinator: ListFlowCoordinator, cellViewModel: ListViewCellModel) {
        compareFlowCoordinator?.addLocationToComparison(viewModel: cellViewModel)
    }
    
}


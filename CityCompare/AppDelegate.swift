//
//  AppDelegate.swift
//  CityCompare
//
//  Created by Antol Peshkov on 30/01/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private lazy var appCoordinator = Appcoordinator(window: self.window!)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .magenta
        window?.makeKeyAndVisible()
        appCoordinator.start()
        return true
    }
    
}


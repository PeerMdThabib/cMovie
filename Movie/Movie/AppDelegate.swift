//
//  AppDelegate.swift
//  Movie
//
//  Created by Sasi M on 24/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LogManager.logI(info: "\(String(describing: Realm.Configuration.defaultConfiguration.fileURL))" )
        return true
    }

}


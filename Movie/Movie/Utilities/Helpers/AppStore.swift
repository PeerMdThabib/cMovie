//
//  AppStore.swift
//  Movie
//
//  Created by Sasi M on 27/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Fabric
import Crashlytics

class AppStore {
    
    class func masterInit() {
        
        Fabric.with([Crashlytics.self])
        AppStore.updateCrashlyticsUserInfo()
        
        LogManager.initialize()
        LogManager.logI(info: "\(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
        LogManager.setPrintToConsole(print: !LIVE_MODE)
        
        UITableViewCell.appearance().separatorInset = .zero
        UITableViewCell.appearance().backgroundColor = UIColor.white
        
    }
    
    
    // MARK: - Crashlytics
    
    class func updateCrashlyticsUserInfo() {
        // Can be configured based on logged in user.
        Crashlytics.sharedInstance().setUserName("Sasi M")
        Crashlytics.sharedInstance().setUserEmail("msasi7274@gmail.com")
    }
}

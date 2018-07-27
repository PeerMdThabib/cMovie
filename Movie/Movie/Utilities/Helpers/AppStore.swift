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

class AppStore {
    
    class func masterInit() {
        
        LogManager.initialize()
        LogManager.logI(info: "\(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
        
        if (LIVE_MODE == true) {
            LogManager.setPrintToConsole(print: false)
        } else {
            LogManager.setPrintToConsole(print: false)
        }
        
        UITableViewCell.appearance().separatorInset = .zero
        UITableViewCell.appearance().backgroundColor = UIColor.white
        
    }
    
}

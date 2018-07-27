//
//  WarningManager.swift
//  Movie
//
//  Created by Sasi M on 27/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import UIKit

final class WarningManager: NSObject {
    
    static let sharedInstance = WarningManager()
    private override init() {}
    
    @objc func createAndPushWarning(message: String, cancel: String) {
        let alertControl = self.createAlertControl(message: message)
        alertControl.addAction(UIAlertAction(title: cancel, style: .default, handler: nil))
        self.displayAlertControl(alert: alertControl)
    }
    
    func createAndPushWarning(message: String, buttons : [(title: String, callBack:(() -> Void)?)]?) {  // cancel button has to be sent in tuple
        let alertControl = self.createAlertControl(message: message)
        if (buttons != nil) {
            for item in buttons! {
                alertControl.addAction(UIAlertAction(title: item.title, style: .default, handler: { (action) in
                    if (item.callBack != nil) {
                        item.callBack!()
                    }
                }))
            }
        }
        self.displayAlertControl(alert: alertControl)
    }
    
    //Mark: Private Methods
    
    private func createAlertControl(message: String) -> UIAlertController {
        return UIAlertController.init(title: NSLocalizedString("C' Moive", comment: ""), message: message, preferredStyle: .alert)
    }
    
    private func displayAlertControl(alert: UIAlertController) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
    }
}



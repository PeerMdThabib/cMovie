//
//  LogManager.swift
//  Movie
//
//  Created by Sasi M on 27/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import UIKit
import Crashlytics

final class LogManager: NSObject {

    enum FilterLevel : Int {
        case lmError = 0
        case lmWarning
        case lmInfo
    }
    
    static var printToConsole = true
    static var MAX_LOG_SIZE: Int64 = 20000
    static var loggingQueue: OperationQueue = OperationQueue.init()
    
    private override init() {}
    
    class func prepare() {
        loggingQueue.maxConcurrentOperationCount = 1
    }
    
    class func setPrintToConsole(print: Bool) {
        printToConsole = print
    }
    
    class func getPrintToConsole() -> Bool {
        return printToConsole
    }
    
    class func logI(info:String) {
        LogManager.appendLog(.lmInfo, message: info)
    }
    
    class func logW(warning:String) {
        LogManager.appendLog(.lmWarning, message: warning)
    }
    
    class func logE(error:String) {
        LogManager.appendLog(.lmError, message: error)
    }
    
    class func appendLog(_ messageLevel: FilterLevel, message: String?) {
        loggingQueue.addOperation({
            //Add to queue and return. May lose some logging in a crash, but it allows to log everything quickly.
            var text: String?
            switch messageLevel {
            case .lmError:
                text = "[ERROR]"
                
            case .lmInfo:
                text = "[INFO]"
                
            case .lmWarning:
                text = "[WARNING]"
                
            }
            text =  "\(text!)" + "\(message ?? "")"
            
            //CLSLog will crash when you get too much text.
            CLSLogv("%@", getVaList([(text!.count > 50000) ? (text! as NSString).substring(to: 50000) : text!]))
            
            if (printToConsole == false) {
                return
            }
            
            print("\(text!)")
        })
    }
}

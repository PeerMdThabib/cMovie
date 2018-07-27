//
//  NetworkManager.swift
//  Movie
//
//  Created by Sasi M on 25/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

final class NetworkManager: NSObject {
    
    var requestQueues: NSMutableSet?
    
    static let sharedInstance = NetworkManager()
    private override init() {
        requestQueues = NSMutableSet.init()
    }
    
    func sendMesage(message: Message) {
        enqueMessage(message: message)
        let operation = Alamofire.request(message.path!, method: message.methodType, parameters: message.parameters, encoding: message.parametersEncoding, headers: nil).responseData { (responseData) in
            message.responseData = responseData
            message.onOperationEnd()
            self.dequeuMessage(message: message)
        }
        message.request = operation
    }
    
    func enqueMessage(message: Message) {
        requestQueues!.add(message)
    }
    
    func dequeuMessage(message: Message) {
        requestQueues!.remove(message)
    }
    
    func cancelAllMessage() {
        for message in requestQueues! {
            (message as! Message).request!.cancel()
        }
        requestQueues?.removeAllObjects()
    }
    
}

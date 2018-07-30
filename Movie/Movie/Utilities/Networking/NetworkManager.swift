//
//  NetworkManager.swift
//  Movie
//
//  Created by Sasi M on 25/07/18.
//  Copyright © 2018 Sasi. All rights reserved.


// Network layer to keep queue of all ongoing network messages
// Sends almofire requests for incoming messages
// Helps cancelling ongoing network message

import UIKit
import Alamofire
import SwiftyJSON

final class NetworkManager: NSObject {
    
    var requestQueues: NSMutableSet?
    
    static let sharedInstance = NetworkManager()
    private override init() {
        requestQueues = NSMutableSet.init()
    }
    
    func hasInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    func sendMesage(message: Message) {
        if (hasInternet() == false) {
            message.onOperationEnd()
            return
        }
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

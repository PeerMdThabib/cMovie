//
//  Message.swift
//  Movie
//
//  Created by Sasi M on 26/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Message: NSObject {
    
    var path: String?
    var request: Alamofire.DataRequest?
    var responseData: Alamofire.DataResponse<Data>?
    
    var successCallBack: ((Message) -> Void)?
    var failureCallBack: ((Message) -> Void)?
    
    func checkAcceptance() -> Bool {
        if (responseData!.error != nil) {
            return false
        }
        
        if (responseData!.response!.statusCode >= 200 &&
            responseData!.response!.statusCode < 300) {
            return true
        }
        
        return false
    }
    
    func onOperationEnd() {
        let isSuccess = checkAcceptance()
        
        if (isSuccess == true) {
            onSuccess()
            if (successCallBack != nil) {
                successCallBack!(self)
            }
        } else {
            onFailure()
            if (failureCallBack != nil) {
                failureCallBack!(self)
            }
        }
    }
    
    func onSuccess() {
        
    }
    
    func onFailure() {
        
    }
}

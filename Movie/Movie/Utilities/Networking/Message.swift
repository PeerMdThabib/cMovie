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
    var methodType: Alamofire.HTTPMethod = .get
    var parameters: Parameters?
    var parametersEncoding: ParameterEncoding = URLEncoding(destination: .httpBody)
    var errorMessage: String?
    
    var successCallBack: ((Message) -> Void)?
    var failureCallBack: ((Message) -> Void)?
    
    func checkAcceptance() -> Bool {
        if (responseData!.error != nil) {
            return false
        }
        
        errorMessage = getErrorMessage()
        
        if (responseData!.response!.statusCode >= 200 &&
            responseData!.response!.statusCode < 300 &&
            errorMessage == nil) {
            return true
        }
        
        return false
    }
    
    func onOperationEnd() {
        let isSuccess = checkAcceptance()
        
        if (isSuccess == true) {
            LogManager.logI(info: "[NETWORK][SUCCESS] " + "\(path!)" + " Code: \(responseData!.response!.statusCode)" + " Response Content: \(getResponseBodyAsString())")
            onSuccess()
            if (successCallBack != nil) {
                successCallBack!(self)
            }
        } else {
            LogManager.logE(error: "[NETWORK][FAILURE] " + "\(path!)" + " Code: \(String(describing: responseData?.response?.statusCode))" + " Error Description: \(responseData?.error?.localizedDescription ?? "") \(errorMessage ?? "")")
            onFailure()
            if (failureCallBack != nil) {
                failureCallBack!(self)
            }
        }
    }
    
    func onSuccess() {
        // DO NOTHING: Subclass to override
    }
    
    func onFailure() {
        if (errorMessage == nil) {
            if (NetworkReachabilityManager()!.isReachable == false) {
                errorMessage = "No internet connection. Please check your connection status and try again."
            } else {
                errorMessage = "Could not connect to the server. Please try again later."
            }
        }
        WarningManager.sharedInstance.createAndPushWarning(message: errorMessage!, cancel: "Ok")
    }
    
    func getErrorMessage() -> String? {
        do {
            let errors = try JSON(data: responseData!.data!)["errors"].array
            if (errors != nil) {
                let errorMessage: NSMutableString = ""
                for error in errors! {
                    errorMessage.append(error.string!)
                }
                return errorMessage as String
            }
        } catch {
            LogManager.logE(error: "Error while saving data in Realm \(error)")
        }
        return nil
    }
    
    func getResponseBodyAsString() -> String! {
        do {
            return try JSON(data: responseData!.data!).rawString(.utf8, options: .sortedKeys)
        } catch {
            LogManager.logE(error: "Error parsing response data \(error)")
            return ""
        }
    }
    
    func getResponseBodyAsDictionary() -> NSDictionary? {
        do {
            return try JSON(data: responseData!.data!).dictionaryObject as NSDictionary?
        } catch {
            LogManager.logE(error: "Error parsing response data \(error)")
            return nil
        }
    }
    
    func getResponseBodyAsList() -> NSArray? {
        do {
            return try JSON(data: responseData!.data!).arrayObject as NSArray?
        } catch {
            LogManager.logE(error: "Error parsing response data \(error)")
            return nil
        }
    }
}

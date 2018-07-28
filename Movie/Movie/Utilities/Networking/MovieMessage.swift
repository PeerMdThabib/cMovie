//
//  MovieMessage.swift
//  Movie
//
//  Created by Sasi M on 26/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class MovieMessage: Message {
    
    var searchQuery: String?
    var resultList: NSArray!
    var totalPage: Int = 0
    
    class func getMovieMessage(withTitle title:String, pageNumber:Int, successCallBack: ((Message?) -> Void)!, failureCallBack: ((Message?) -> Void)!) -> MovieMessage {
        let movieMessage: MovieMessage = MovieMessage()
        movieMessage.successCallBack = successCallBack
        movieMessage.failureCallBack = failureCallBack
        movieMessage.methodType = .post
        movieMessage.searchQuery = title
        movieMessage.path = MOVIE_URL
        movieMessage.parameters = ["query": title, "page": pageNumber]
        return movieMessage
    }
    
    override func onSuccess() {
        if (responseData?.data != nil) {
            
            let responseDict = getResponseBodyAsDictionary()
            if (responseDict == nil) {
                return
            }
            
            totalPage = responseDict!["total_pages"] as? Int ?? 0
            resultList = responseDict!["results"] as! NSArray

            if (resultList.count == 0) {
                WarningManager.createAndPushWarning(message: "No results found. Please try again later", cancel: "Ok")
                return
            }
        }
    }
}

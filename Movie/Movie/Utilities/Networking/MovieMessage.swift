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
    var resultList: NSMutableArray = NSMutableArray.init()
    var totalPage: Int = 0
    
    class func getMovieMessage(withTitle title:String, pageNumber:Int, successCallBack: ((Message?) -> Void)!, failureCallBack: ((Message?) -> Void)!) -> MovieMessage {
        let movieMessage: MovieMessage = MovieMessage()
        movieMessage.successCallBack = successCallBack
        movieMessage.failureCallBack = failureCallBack
        movieMessage.methodType = .post
        movieMessage.searchQuery = title
        movieMessage.path = "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838"
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
            let results = responseDict!["results"] as! NSArray

            if (results.count == 0) {
                WarningManager.sharedInstance.createAndPushWarning(message: "No results found. Please try again later", cancel: "Ok")
                return
            }

            do {
                MovieDataHandler.sharedInstance.clearCachedMovieData()
                let realm = try Realm()
                for response in results {
                    let movie: Movie = Movie.createMovie(withDetails: response as! NSDictionary, searchQuery: searchQuery!)
                    try realm.write {
                        realm.add(movie)
                    }
                    resultList.add(movie)
                }
            } catch {
                LogManager.logE(error: "Error while saving data in Realm \(error)")
            }
        }
    }
}

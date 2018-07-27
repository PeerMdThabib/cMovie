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
    var resultList: NSMutableArray?
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
            resultList = NSMutableArray.init()
            do {
                let jsonData = try JSON(data: responseData!.data!)
                totalPage = jsonData.dictionaryObject!["total_pages"] as! Int
                let realm = try Realm()
                for i in (0..<jsonData["results"].count) {
                    let movieDetails = jsonData["results"][i].dictionaryObject! as NSDictionary
                    let movie: Movie = Movie.createMovie(withDetails: movieDetails, searchQuery: searchQuery!)
                    try realm.write {
                        realm.add(movie)
                    }
                    resultList!.add(movie)
                }
            } catch {
                print("Error while saving data in Realm \(error)")
            }
        }
    }
}

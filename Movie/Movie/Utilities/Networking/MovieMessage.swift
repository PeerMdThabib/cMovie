//
//  MovieMessage.swift
//  Movie
//
//  Created by Sasi M on 26/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import Foundation
import SwiftyJSON

class MovieMessage: Message {
    
    @objc class func getMovieMessage(withTitle title:String, pageNumber:Int, successCallBack: ((Message?) -> Void)!, failureCallBack: ((Message?) -> Void)!) -> MovieMessage {
        let movieMessage: MovieMessage = MovieMessage()
        movieMessage.successCallBack = successCallBack
        movieMessage.failureCallBack = failureCallBack
        
        movieMessage.path = "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=" + "\(title)" + "&page=" + "\(pageNumber)"
        
        return movieMessage
    }
    
    override func onSuccess() {
        self.request?.responseJSON(completionHandler: { (responseData) in
            let jsonData = try! JSON(data: responseData.data!)
            print("\(jsonData)")
        })
    }
}

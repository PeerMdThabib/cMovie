//
//  MovieDataHandler.swift
//  Movie
//
//  Created by Sasi M on 25/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import Foundation
import SwiftyJSON

final class MovieDataHandler {
    
    static let sharedInstance = MovieDataHandler()
    private init() {
        movieList = NSMutableArray.init()
    }
    
    var movieTitle: String?
    var currentPage:Int = 0
    var totalPages: Int = 0
    
    var movieList: NSMutableArray?
    var isDownloading: Bool = false
    
    func downloadMovies(withTitle title:String, onCompletion completion:@escaping () -> Void) {
        movieList?.removeAllObjects()
        downladMovies(withTitle: title, onPageNumber: 1, onCompletion: completion)
    }
    
    func downloadMoviesFromNextPage(onCompletion completion:@escaping () -> Void) {
        if (isDownloading == true) {
            return
        }
        downladMovies(withTitle: movieTitle!, onPageNumber: currentPage+1, onCompletion: completion)
    }
    
    func downladMovies(withTitle title:String, onPageNumber page:Int, onCompletion completion:@escaping () -> Void) {
        movieTitle = title
        currentPage = page
        isDownloading = true
        let movieMessage = MovieMessage.getMovieMessage(withTitle: title, pageNumber: currentPage, successCallBack: { (message) in
            self.isDownloading = false
            self.movieList?.addObjects(from: (message as! MovieMessage).resultList as! [Any])
            completion()
        }) { (message) in
            self.isDownloading = false
            completion()
        }
        NetworkManager.sharedInstance.sendMesage(message: movieMessage)
    }
    
    
    func getMoviesCount() -> Int {
        if (movieList == nil) {
            return 0
        }
        var count = movieList!.count
        if (hasNextPage() == true) {
            count += 1
        }
        return count
    }
    
    func hasNextPage() -> Bool {
        return (totalPages > currentPage)
    }
    
    func getMovie(atIndex index:Int) -> Movie? {
        if (movieList != nil && movieList!.count > index) {
            return movieList![index] as? Movie
        }
        return nil
    }
}

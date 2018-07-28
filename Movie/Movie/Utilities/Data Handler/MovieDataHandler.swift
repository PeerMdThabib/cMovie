//
//  MovieDataHandler.swift
//  Movie
//
//  Created by Sasi M on 25/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

final class MovieDataHandler {
    
    var movieTitle: String?
    var currentPage:Int = 0
    var totalPages: Int = 0
    
    var searchQueryList: NSMutableArray
    var movieList: NSMutableArray?
    var isDownloading: Bool = false
    
    static let sharedInstance = MovieDataHandler()
    private init() {
        movieList = NSMutableArray.init()
        searchQueryList = NSMutableArray.init()
        
        let savedQueires = UserDefaults.standard.value(forKey: "SearchQueryList") as? [Any]
        if (savedQueires != nil) {
            searchQueryList.addObjects(from: savedQueires!)
        }
    }
    
    func downloadMovies(withTitle title:String, onCompletion completion:@escaping () -> Void) {
        reset()
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
            self.totalPages = (message as! MovieMessage).totalPage
            if (self.movieList!.count > 0) {
                self.saveSearchQuery()
            }
            completion()
        }) { (message) in
            self.loadCachedMovieData()
            self.isDownloading = false
            completion()
        }
        NetworkManager.sharedInstance.sendMesage(message: movieMessage)
    }
    
    func loadCachedMovieData() {
        movieList?.addObjects(from: retrieveMovieData().value(forKey: "self") as! [Any])
        totalPages = 1
    }
    
    func clearCachedMovieData() {
        if (currentPage > 1) {
            return
        }
        let realm = try! Realm()
        try! realm.write {
            realm.delete(retrieveMovieData())
        }
    }
    
    func retrieveMovieData() -> Results<Movie> {
        let realm = try! Realm()
        return realm.objects(Movie.self).filter("query = '\(movieTitle!)'")
    }
    
    func reset() {
        movieList?.removeAllObjects()
        totalPages = 0
        currentPage = 0
        isDownloading = false
        movieTitle = ""
    }
}

extension MovieDataHandler {
    
    func getMoviesCount() -> Int {
        if (movieList == nil) {
            return 0
        }
        var count = movieList!.count
        if (count > 0 && hasNextPage() == true) {
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


extension MovieDataHandler {
    
    func getSuccessfulSearchQueries() -> NSArray {
        return searchQueryList
    }
    
    func saveSearchQuery() {
        if (searchQueryList.contains(movieTitle!)) {
            searchQueryList.remove(movieTitle!)
        }
        if (searchQueryList.count >= 10) {
            searchQueryList.removeLastObject()
        }
        searchQueryList.insert(movieTitle!, at: 0)
        UserDefaults.standard.set(searchQueryList, forKey: "SearchQueryList")
        UserDefaults.standard.synchronize()
    }
    
    
    func getSearchQueryCount() -> Int {
        return searchQueryList.count
    }
    
    func getSearchQuery(atIndex index: Int) -> String {
        return searchQueryList[index] as! String
    }
}


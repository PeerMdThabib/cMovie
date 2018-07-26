//
//  MovieDataHandler.swift
//  Movie
//
//  Created by Sasi M on 25/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import Foundation

final class MovieDataHandler {
    
    static let sharedInstance = MovieDataHandler()
    private init() {}
    
    var movieTitle: String?
    var currentPage:Int = 0
    var totalPages: Int = 0
    
    var movieList: NSMutableArray?
    
    func downloadMovies(withTitle title:String, onCompletion completion:() -> Void) {
        downladMovies(withTitle: title, onPageNumber: 1, onCompletion: completion)
    }
    
    func downloadMoviesFromNextPage(onCompletion completion:() -> Void) {
        downladMovies(withTitle: movieTitle!, onPageNumber: currentPage+1, onCompletion: completion)
    }
    
    func downladMovies(withTitle title:String, onPageNumber page:Int, onCompletion completion:() -> Void) {
        movieTitle = title
        currentPage = page
    }
    
    func downloadMoviePosters(forMovies movies:NSArray) {
        
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
    
    func getMovie(atIndex index:Int) {
        if (movieList != nil && movieList!.count > index) {
            
        }
    }
}

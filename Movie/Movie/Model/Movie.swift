//
//  Movie.swift
//  Movie
//
//  Created by Sasi M on 27/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import Foundation
import RealmSwift

class Movie: Object {
    @objc dynamic var query: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var releaseDate: String = ""
    @objc dynamic var fullOverview: String = ""
    @objc dynamic var posterPath: String = ""
    var formattedReleaseDate: String = ""
    
    
    public class func createMovie(withDetails dictionary: NSDictionary, searchQuery: String) -> Movie {
        let movie : Movie = Movie()
        movie.query = searchQuery
        movie.title = dictionary["title"] as? String ?? ""
        movie.releaseDate = dictionary["release_date"] as? String ?? ""
        movie.fullOverview = dictionary["overview"] as? String ?? ""
        movie.posterPath = dictionary["poster_path"] as? String ?? ""
        movie.formattedReleaseDate = movie.getFormattedReleaseDateString()
        return movie
    }
    
    func getFormattedReleaseDateString() -> String {
        
        if (releaseDate.count == 0) {
            return ""
        }
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-mm-dd"
        let formattedDate = formatter.date(from: releaseDate)
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: formattedDate!)
    }
}


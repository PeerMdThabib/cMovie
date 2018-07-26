//
//  MovieListController.swift
//  Movie
//
//  Created by Sasi M on 25/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import UIKit

class MovieSearchListController: UIViewController {

    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    
}

extension MovieSearchListController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text == nil || searchBar.text!.count == 0) {
            return
        }
        searchBar.endEditing(true)
        MovieDataHandler.sharedInstance.downloadMovies(withTitle: searchBar.text!) {
            self.movieTableView.reloadData()
        }
    }
}

extension MovieSearchListController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieDataHandler.sharedInstance.getMoviesCount()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie: Movie? = MovieDataHandler.sharedInstance.getMovie(atIndex: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        cell.textLabel?.text = movie?.title
        return cell
    }
}

extension MovieSearchListController: UITableViewDelegate {
    
}




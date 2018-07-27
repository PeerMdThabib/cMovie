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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.alpha = 0
    }
    
}

extension MovieSearchListController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text == nil || searchBar.text!.count == 0) {
            return
        }
        searchBar.endEditing(true)
        MovieDataHandler.sharedInstance.downloadMovies(withTitle: searchBar.text!) {
            self.movieTableView.reloadData()
            UIView.animate(withDuration: 0.25, animations: {
                self.movieTableView.alpha = 1
            })
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
        var cell: UITableViewCell? = nil
        
        if (movie != nil) {
            let movieCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
            movieCell.loadData(forMovie: movie!)
            cell = movieCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
            MovieDataHandler.sharedInstance.downloadMoviesFromNextPage {
                self.movieTableView.reloadData()
            }
        }
        
        return cell!
    }
}

extension MovieSearchListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let movie: Movie? = MovieDataHandler.sharedInstance.getMovie(atIndex: indexPath.row)
        if (movie == nil) {
            return 41
        }
        return 222
    }
    
}




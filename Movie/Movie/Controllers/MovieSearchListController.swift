//
//  MovieListController.swift
//  Movie
//
//  Created by Sasi M on 25/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import UIKit

class MovieSearchListController: UIViewController {

    enum DataType : NSInteger {
        case None = 0,
        Movie,
        SearchQuery
    }
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var cancelButtonTrailingConstraint: NSLayoutConstraint!
    
    var dataType: DataType = .None
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cancelButtonTrailingConstraint.constant = -65
        view.layoutIfNeeded()
    }
    
    @IBAction func searchCancelButtonTapped(_ sender: Any) {
        hideCancelAndReloadMovies()
    }
    
    func hideCancelAndReloadMovies() {
        cancelButtonTrailingConstraint.constant = -65
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.dataType = .Movie
            self.movieSearchBar.endEditing(true)
            self.movieTableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
}

extension MovieSearchListController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        dataType = .SearchQuery
        if (MovieDataHandler.sharedInstance.getSearchQueryCount() > 0) {
            displayTableViewWithAnimation()
        }
        cancelButtonTrailingConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text == nil || searchBar.text!.count == 0) {
            return
        }
        startMovieSearch()
    }
    
    func startMovieSearch() {
        movieSearchBar.endEditing(true)
        MovieDataHandler.sharedInstance.downloadMovies(withTitle: movieSearchBar.text!) {
            self.displayTableViewWithAnimation()
        }
        hideCancelAndReloadMovies()
    }
    
    func displayTableViewWithAnimation() {
        movieTableView.reloadSections(IndexSet(integer: 0), with: .fade)
        if (movieTableView.alpha == 0) {
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
        switch dataType {
        case .Movie:
            return MovieDataHandler.sharedInstance.getMoviesCount()
            
        case .SearchQuery:
            return MovieDataHandler.sharedInstance.getSearchQueryCount()
            
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell? = nil
        
        switch dataType {
        case .Movie:
            let movie: Movie? = MovieDataHandler.sharedInstance.getMovie(atIndex: indexPath.row)
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
            
        case .SearchQuery:
            let searchQuery = MovieDataHandler.sharedInstance.getSearchQuery(atIndex: indexPath.row)
            let searchCell = tableView.dequeueReusableCell(withIdentifier: "SearchQueryCell", for: indexPath) as! SearchQueryCell
            searchCell.searchTitleLabel.text = searchQuery
            cell = searchCell
            
        default:
            break
        }
        
        cell!.selectionStyle = .none
        return cell!
    }
}

extension MovieSearchListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataType {
        case .SearchQuery:
            movieSearchBar.text = MovieDataHandler.sharedInstance.getSearchQuery(atIndex: indexPath.row)
            startMovieSearch()
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
}




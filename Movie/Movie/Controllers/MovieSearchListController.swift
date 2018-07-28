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
    @IBOutlet weak var launchLabel: UILabel!
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonTrailingConstraint: NSLayoutConstraint!
    
    let movieDataHandler = MovieDataHandler.init()
    var dataType: DataType = .None
    var isFirstTimeMovieDisplay = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide tableView on initial load to avoid showing empty table
        movieTableView.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide navigation and search bars for initial load from launch
        // For smoother transition between launch screen and root controller
        navigationController?.setNavigationBarHidden(true, animated: false)
        searchBarTopConstraint.constant = -56
        cancelButtonTrailingConstraint.constant = -65
        view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Animate launch label with scale transfermation
        // Present navigation and search bar from the top with animation
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .beginFromCurrentState, animations: {
            self.launchLabel.transform = CGAffineTransform(scaleX: 3, y: 3)
            self.launchLabel.alpha = 0
        }) { (finished) in
            self.launchLabel.removeFromSuperview()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.searchBarTopConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func searchCancelButtonTapped(_ sender: Any) {
        // IBAction to cancel search
        hideCancelAndReloadMovies()
    }
    
    func hideCancelAndReloadMovies() {
        // Cancels search operations and reloads previously downloaded movie results
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


// Extension to handel searchBar delegate
// Change data type to .SearchQuery and reuse movieTableView to display successful search queries
// Initiate movie search request to MOvieDataHandler and prepare movieTable for movie results
extension MovieSearchListController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        dataType = .SearchQuery
        if (movieDataHandler.getSearchQueryCount() > 0) {
            reloadTableViewWithAnimation()
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
        movieDataHandler.downloadMovies(withTitle: movieSearchBar.text!) {
            self.isFirstTimeMovieDisplay = true
            self.reloadTableViewWithAnimation()
        }
        hideCancelAndReloadMovies()
    }
    
    func reloadTableViewWithAnimation() {
        movieTableView.alpha = 1
        if (isFirstTimeMovieDisplay == true) {
            // Fix for incorrect height calculation using 'UITableViewAutomaticDimension' on initial load.
            // Reloading table will fix it. Need to call this only on first time load
            // Issue ref : https://github.com/smileyborg/TableViewCellWithAutoLayoutiOS8/issues/10
            isFirstTimeMovieDisplay = false
            movieTableView.reloadData()
            movieTableView.setNeedsLayout()
            movieTableView.layoutIfNeeded()
            movieTableView.reloadData()
        } else {
            movieTableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
}


// Extension to handel movieTableView Datasource
// Datasource can change between .Movie and .SearchQuery
// Loads MovieCell and LoadingCell for .Movie type and SearchCell for .SearchQuery type
// Initiates nextPage data load via MovieDataHandler
extension MovieSearchListController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dataType {
        case .Movie:
            return movieDataHandler.getMoviesCount()
            
        case .SearchQuery:
            return movieDataHandler.getSearchQueryCount()
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell? = nil
        
        switch dataType {
        case .Movie:
            let movie: Movie? = movieDataHandler.getMovie(atIndex: indexPath.row)
            if (movie != nil) {
                let movieCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
                movieCell.loadData(forMovie: movie!)
                cell = movieCell
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
                movieDataHandler.downloadMoviesFromNextPage {
                    self.movieTableView.reloadData()
                }
            }
            
        case .SearchQuery:
            let searchQuery = movieDataHandler.getSearchQuery(atIndex: indexPath.row)
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


// Extension to handel movieTableView delegate
// Dynamic height calculation using UITableViewAutomaticDimension for lengthy movie overview
// Handle search query selection from previous successful search queries
// Keeps footer height to hide empty cells in Plain type movieTableView
extension MovieSearchListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataType {
        case .SearchQuery:
            movieSearchBar.text = movieDataHandler.getSearchQuery(atIndex: indexPath.row)
            startMovieSearch()
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
}




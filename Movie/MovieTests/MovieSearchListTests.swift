//
//  MovieSearchListTests.swift
//  MovieTests
//
//  Created by Sasi M on 28/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import Quick
import Nimble

@testable import Movie

class MovieSearchListTests: QuickSpec {
    
    override func spec() {
        var subject: MovieSearchListController!
        
        describe("MovieSearchListController") {
            beforeEach {
                subject = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieSearchListController") as! MovieSearchListController
                _ = subject.view
            }
            
            context("when view is loaded") {
                it("should have 0 movies loaded") {
                    subject.dataType = .Movie
                    expect(subject.movieTableView.numberOfRows(inSection: 0)).to(equal(0))
                }
                it("should have 0 search query loaded if no success query found") {
                    subject.movieDataHandler.searchQueryList = []
                    subject.dataType = .SearchQuery
                    expect(subject.movieTableView.numberOfRows(inSection: 0)).to(equal(0))
                }
            }
            
            context("when search enabled") {
                beforeEach {
                    subject.movieDataHandler.searchQueryList = ["Avengers", "Batman"]
                    subject.dataType = .SearchQuery
                }
                
                it("should have previous success search queries loaded") {
                    expect(subject.movieTableView.numberOfRows(inSection: 0)).to(equal(2))
                }
                it("should show search query") {
                    let cell = subject.tableView(subject.movieTableView, cellForRowAt: IndexPath(row: 0, section: 0))
                    expect(cell is SearchQueryCell).to(equal(true))
                    expect((cell as! SearchQueryCell).searchTitleLabel.text).to(equal("Avengers"))
                }
            }
            
            context("when movie downloaded") {
                beforeEach {
                    subject.movieDataHandler.movieList = [Movie.createMovie(withDetails: ["title":"Batman - The Dark Knight",
                                                                                          "release_date":"2008-07-16",
                                                                                          "overview":"Movie Overview",
                                                                                          "poster_path":"1hRoyzDtpgMU7Dz4JF22RANzQO7.jpg"], searchQuery: "Avengers")]
                    subject.movieDataHandler.movieTitle = "Avengers"
                    subject.dataType = .Movie
                }
                
                it("should have movies loaded") {
                    expect(subject.movieTableView.numberOfRows(inSection: 0)).to(equal(1))
                }
                it("should show movie") {
                    let cell = subject.tableView(subject.movieTableView, cellForRowAt: IndexPath(row: 0, section: 0))
                    expect(cell is MovieCell).to(equal(true))
                    expect((cell as! MovieCell).detailsLabel.text).to(equal("Batman - The Dark Knight\n16 July 2008\nMovie Overview"))
                }
                it("should show next page loader") {
                    subject.movieDataHandler.totalPages = 2
                    let cell = subject.tableView(subject.movieTableView, cellForRowAt: IndexPath(row: 1, section: 0))
                    expect(cell is LoadingCell).to(equal(true))
                }
            }
        }
    }
    
}

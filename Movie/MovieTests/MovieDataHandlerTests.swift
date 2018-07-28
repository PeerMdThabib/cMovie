//
//  MovieDataHandlerTests.swift
//  MovieTests
//
//  Created by Sasi M on 28/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import Quick
import Nimble

@testable import Movie

class MovieDataHandlerTests: QuickSpec {
    override func spec() {
        let movieDataHandler = MovieDataHandler.init()
        let savedQueires = UserDefaults.standard.value(forKey: "SearchQueryList") as? [Any]
        
        describe("MovieDataHandler") {
            context("On Init") {
                it("should have 0 movies loaded") {
                    expect(movieDataHandler.getMoviesCount()).to(equal(0))
                }
                it("next page will not be available") {
                    expect(movieDataHandler.hasNextPage()).to(equal(false))
                }
                it("should return nil for movie at index") {
                    expect(movieDataHandler.getMovie(atIndex: 0)).to(beNil())
                }
                it("should have search query from User deafults loaded") {
                    expect(movieDataHandler.getSearchQueryCount()).to(equal(savedQueires?.count))
                }
                it("should return saved search queries at given index") {
                    if (savedQueires != nil && savedQueires!.count > 0) {
                        expect(movieDataHandler.getSearchQuery(atIndex: 0)).to(equal(savedQueires![0] as? String))
                    }
                }
            }
        }
        
        describe("MovieDataHandlet Search") {
            
            beforeEach {
                movieDataHandler.searchQueryList = []
            }
            
            context("On Search Start") {
                movieDataHandler.downloadMovies(withTitle: "Avengers", onCompletion: {
                })
                it("should have 0 search queries") {
                    expect(movieDataHandler.getSearchQueryCount()).to(equal(0))
                }
                it("next page will not be available")    {
                    expect(movieDataHandler.hasNextPage()).to(equal(false))
                }
                it("current page must be 0") {
                    expect(movieDataHandler.currentPage).to(equal(0))
                }
                it("total pages must be 0") {
                    expect(movieDataHandler.totalPages).to(equal(0))
                }
                it("movies count muse be 0") {
                    expect(movieDataHandler.getMoviesCount()).to(equal(0))
                }
            }
            
            context("On Search Completion") {
                movieDataHandler.downloadMovies(withTitle: "Avengers", onCompletion: {
                    
                    it("should have recent query at first in search query list") {
                        expect(movieDataHandler.getSearchQuery(atIndex: 0)).to(equal("Avengers"))
                    }
                    it("should have 1 search query") {
                        expect(movieDataHandler.getSearchQueryCount()).to(equal(1))
                    }
                    it("next page will be available") {
                        expect(movieDataHandler.hasNextPage()).to(equal(true))
                    }
                    it("current page must be 1") {
                        expect(movieDataHandler.currentPage).to(equal(1))
                    }
                    it("total pages must be greater than 0") {
                        expect(movieDataHandler.totalPages > 0).to(equal(true))
                    }
                    it("movies count must be greater than 0") {
                        expect(movieDataHandler.getMoviesCount() > 0).to(equal(true))
                    }
                    it("movies at index 0 must not be nil") {
                        expect(movieDataHandler.getMovie(atIndex: 0) != nil).to(equal(true))
                    }
                })
            }
        }
    }
}

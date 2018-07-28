//
//  MovieModelTests.swift
//  MovieTests
//
//  Created by Sasi M on 28/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import Quick
import Nimble

@testable import Movie

class MovieModelTests: QuickSpec {
    override func spec() {
        describe("Movie") {
            
            let movie: Movie = Movie.createMovie(withDetails: ["title":"Batman - The Dark Knight",
                                                               "release_date":"2008-07-16",
                                                               "overview":"Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets. The partnership proves to be effective, but they soon find themselves prey to a reign of chaos unleashed by a rising criminal mastermind known to the terrified citizens of Gotham as the Joker.",
                                                               "poster_path":"1hRoyzDtpgMU7Dz4JF22RANzQO7.jpg"], searchQuery: "Batman")
            
            context("On Init") {
                it("should match the title from the response dict") {
                    expect(movie.title).to(equal("Batman - The Dark Knight"))
                }
                it("should match the release date from the response dict") {
                    expect(movie.releaseDate).to(equal("2008-07-16"))
                }
                it("should match the overview from the response dict") {
                    expect(movie.fullOverview).to(equal("Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets. The partnership proves to be effective, but they soon find themselves prey to a reign of chaos unleashed by a rising criminal mastermind known to the terrified citizens of Gotham as the Joker."))
                }
                it("should match the poster path from the response dict") {
                    expect(movie.posterPath).to(equal("1hRoyzDtpgMU7Dz4JF22RANzQO7.jpg"))
                }
                it("should have formatted address string") {
                    expect(movie.getFormattedReleaseDateString()).to(equal("16 July 2008"))
                }
            }
            
            context("Date conversion") {
                it("should match release date from response") {
                    movie.releaseDate = "2018-01-1"
                    expect(movie.getFormattedReleaseDateString()).to(equal("01 January 2018"))
                    movie.releaseDate = "2015-09-21"
                    expect(movie.getFormattedReleaseDateString()).to(equal("21 September 2015"))
                    movie.releaseDate = "2010-04-17"
                    expect(movie.getFormattedReleaseDateString()).to(equal("17 April 2010"))
                }
            }
            
            context("Getting Image size") {
                it("should give based on height") {
                    expect(movie.getImageSizeString(forHeight: 140)).to(equal("w185"))
                    expect(movie.getImageSizeString(forHeight: 50)).to(equal("w92"))
                    expect(movie.getImageSizeString(forHeight: 270)).to(equal("w500"))
                }
            }
        }
    }
}
    


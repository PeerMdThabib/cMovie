//
//  MovieCell.swift
//  Movie
//
//  Created by Sasi M on 27/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import UIKit

import AlamofireImage

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var detailsLabel: UILabel!
    
    // MARK: Init Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func loadData(forMovie movie:Movie) {
        
        let attriTitleString = NSAttributedString(string:"\(movie.title)" + "\n",
                                                  attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,
                                                               NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)])
        
        let attriReleaseDateString = NSAttributedString(string:"\(movie.releaseDate)" + "\n" + "\n",
                                                        attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray,
                                                                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
        
        let attriOverviewString = NSAttributedString(string:movie.fullOverview,
                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,
                                                                  NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
        
        let attriMovieDetailString = NSMutableAttributedString()
        attriMovieDetailString.append(attriTitleString)
        attriMovieDetailString.append(attriReleaseDateString)
        attriMovieDetailString.append(attriOverviewString)
        
        detailsLabel.attributedText = attriMovieDetailString
        
        if (movie.posterPath.count > 0) {
            posterImageView.af_setImage(
                withURL: URL(string: "http://image.tmdb.org/t/p/w92" + movie.posterPath)!,
                placeholderImage: nil,
                filter: AspectScaledToFitSizeFilter(size: posterImageView.frame.size) as ImageFilter,
                imageTransition: .crossDissolve(0.2)
            )
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        detailsLabel.text = ""
        posterImageView.af_cancelImageRequest()
        posterImageView.layer.removeAllAnimations()
        posterImageView.image = nil
    }
    
}

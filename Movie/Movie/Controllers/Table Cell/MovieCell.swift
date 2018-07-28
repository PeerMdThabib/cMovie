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
    
    func loadData(forMovie movie:Movie) {
        
        // Attributed string for Movie Title / Release Date / Overview design
        // Big and black Movie title at the top
        // Followed by medium sized release date in gray
        // Followed by smaller sized full movie overview in black
        let attriTitleString = NSAttributedString(string:"\(movie.title)" + "\n",
                                                  attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,
                                                               NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)])
        
        let attriReleaseDateString = NSAttributedString(string:"\(movie.formattedReleaseDate)" + "\n",
                                                        attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray,
                                                                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)])
        
        let attriOverviewString = NSAttributedString(string:movie.fullOverview,
                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,
                                                                  NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
        
        let attriMovieDetailString = NSMutableAttributedString()
        attriMovieDetailString.append(attriTitleString)
        attriMovieDetailString.append(attriReleaseDateString)
        attriMovieDetailString.append(attriOverviewString)
        
        detailsLabel.attributedText = attriMovieDetailString
        
        // Seemless image download and loading into ImageView using AlamofireImage
        // Images made AspectFill to fill the imageView to keep consistency with the movie details text
        if (movie.posterPath.count > 0) {
            posterImageView.af_setImage(
                withURL: URL(string: IMAGE_URL + movie.getImageSizeString(forHeight: Float(frame.size.height)) + movie.posterPath)!,
                placeholderImage: UIImage.init(named: "PosterPlaceholder"),
                filter: AspectScaledToFillSizeFilter(size: posterImageView.frame.size) as ImageFilter,
                imageTransition: .crossDissolve(0.2)
            )
        } else {
            posterImageView.image = UIImage.init(named: "PosterPlaceholder")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Cancel any ongoing AlamofireImage download request
        // Also remove animation layers from image view for cell reuse
        detailsLabel.text = ""
        posterImageView.af_cancelImageRequest()
        posterImageView.layer.removeAllAnimations()
        posterImageView.image = nil
    }
    
}

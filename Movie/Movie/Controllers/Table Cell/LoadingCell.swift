//
//  LoadingCell.swift
//  Movie
//
//  Created by Sasi M on 27/07/18.
//  Copyright © 2018 Sasi. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var retryButton: UIButton!
    
    var request: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        retryButton.alpha = 0
    }
    
    
    func startLoading(withDataRequest dataRequest:(() -> Void)!) {
        loadingIndicator.startAnimating()
        request = dataRequest
        dataRequest()
    }
    
    func displayRetryOption() {
        loadingIndicator.stopAnimating()
        UIView.animate(withDuration: 0.5) {
            self.loadingIndicator.alpha = 0
            self.retryButton.alpha = 1
        }
    }
    
    @IBAction func retryButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.loadingIndicator.alpha = 1
            self.retryButton.alpha = 0
        }
        startLoading(withDataRequest: request)
    }
}

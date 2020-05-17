//
//  MovieDetailsViewController.swift
//  MovieList
//
//  Created by Vivatum on 15/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import UIKit
import CocoaLumberjack

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var posterImageview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ratingTitleLabel: UILabel!
    @IBOutlet weak var ratingValueLabel: UILabel!
    
    @IBOutlet weak var releaseTitileLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var overviewTextView: UITextView!
    
    @IBOutlet weak var posterWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var posterHeightConstraint: NSLayoutConstraint!
    
    private var favoriteButton: UIBarButtonItem?
    public var movieData: Movie?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabels()
        populateView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupPosterConstraints()
    }
    
    // MARK: - Setup View
    
    private func setupLabels() {
        titleLabel.textColor = AppColorScheme.movieTitle
        
        ratingTitleLabel.textColor = AppColorScheme.movieTitleLight
        ratingTitleLabel.text = "rating.title.label".localized
        releaseTitileLabel.textColor = AppColorScheme.movieTitleLight
        releaseTitileLabel.text = "release.titile.label".localized
        
        ratingValueLabel.textColor = AppColorScheme.movieSubtitle
        releaseDateLabel.textColor = AppColorScheme.movieSubtitle
        overviewTextView.textColor = AppColorScheme.movieSubtitle
    }
    
    private func setupPosterConstraints() {
        let width = self.view.bounds.width / 3
        let height = width / 3 * 4
        posterWidthConstraint.constant = width
        posterHeightConstraint.constant = height
    }
    
    // MARK: - Populate View
    
    private func populateView() {
        guard let movie = self.movieData else { return }
        
        if let title = movie.title {
            self.titleLabel.text = title
        }
        
        posterImageview.setupImageByPath(movie.posterPath)
        
        var ratingString = "0.0"
        if let rating = movie.vote {
            ratingString = String(rating)
        }
        ratingValueLabel.text = ratingString
        
        var dateString = ""
        if let date = movie.releaseDate {
            dateString = date.toString(format: .fullDate)
        }
        releaseDateLabel.text = dateString
        
        if let overview = movie.overview {
           overviewTextView.text = overview
        }
        
        setupFavoriteButton()
    }
    
    
    // MARK: - Favorite Actions
    
    @objc func favoriteButtonAction() {
        DDLogInfo("Favorite button pressed")
        self.movieData?.changeFavoriteStatus()
    }
    
    private func setupFavoriteButton() {
        guard let movie = self.movieData else { return }
        DispatchQueue.main.async {
            let buttonIcon: UIImage? = movie.favorite ? UIImage(named: "starFavorited") : UIImage(named: "star")
            self.favoriteButton = UIBarButtonItem(image: buttonIcon, style: .plain, target: self, action: #selector(self.favoriteButtonAction))
            self.navigationItem.setRightBarButton(self.favoriteButton, animated: true)
        }
    
    }
}

extension MovieDetailsViewController: MovieFavoriteDelegate {
    func favoriteStatusUpdated() {
        self.setupFavoriteButton()
    }
}

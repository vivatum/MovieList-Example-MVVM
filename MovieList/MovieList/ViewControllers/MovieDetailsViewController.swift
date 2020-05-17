//
//  MovieDetailsViewController.swift
//  MovieList
//
//  Created by Vivatum on 15/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import UIKit
import CocoaLumberjack

final class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
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
        
        self.title = "details.nav.titile".localized
        self.setupLabels()
        self.populateView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupPosterConstraints()
    }
    
    // MARK: - Setup View
    
    private func setupLabels() {
        self.titleLabel.textColor = AppColorScheme.movieTitle
        
        self.ratingTitleLabel.textColor = AppColorScheme.movieTitleLight
        self.ratingTitleLabel.text = "rating.title.label".localized
        self.releaseTitileLabel.textColor = AppColorScheme.movieTitleLight
        self.releaseTitileLabel.text = "release.titile.label".localized
        
        self.ratingValueLabel.textColor = AppColorScheme.movieSubtitle
        self.releaseDateLabel.textColor = AppColorScheme.movieSubtitle
        self.overviewTextView.textColor = AppColorScheme.movieSubtitle
    }
    
    private func setupPosterConstraints() {
        let width = self.view.bounds.width / 3
        let height = width / 3 * 4
        self.posterWidthConstraint.constant = width
        self.posterHeightConstraint.constant = height
    }
    
    // MARK: - Populate View
    
    private func populateView() {
        guard let movie = self.movieData else { return }
        movie.detailDelegate = self
        
        if let title = movie.title {
            self.titleLabel.text = title
        }
        
        self.posterImageview.setupImageByPath(movie.posterPath)
        
        var ratingString = "0.0"
        if let rating = movie.vote {
            ratingString = String(rating)
        }
        self.ratingValueLabel.text = ratingString
        
        var dateString = ""
        if let date = movie.releaseDate {
            dateString = date.toString(format: .fullDate)
        }
        self.releaseDateLabel.text = dateString
        
        if let overview = movie.overview {
           self.overviewTextView.text = overview
        }
        
        self.setupFavoriteButton()
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

extension MovieDetailsViewController: MovieDetailDelegate {
    func favoriteStatusUpdated() {
        self.setupFavoriteButton()
    }
}

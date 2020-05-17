//
//  MovieTableViewCell.swift
//  MovieList
//
//  Created by Vivatum on 15/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import UIKit
import CocoaLumberjack


final class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var movieData: Movie? {
        didSet {
            populateCellContent()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    
    // MARK: - Favorite Status Action
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        DDLogInfo("Favorite button pressed")
        self.movieData?.changeFavoriteStatus()
    }
    
    // MARK: - Cell content
    
    private func setupCell() {
        self.titleLabel.textColor = AppColorScheme.movieTitle
        self.subtitleLabel.textColor = AppColorScheme.movieSubtitle
    }
    
    private func populateCellContent() {
        guard let movie = self.movieData else { return }
        movie.delegate = self
        self.titleLabel.text = movie.title
        if let data = movie.releaseDate {
            self.subtitleLabel.text = data.toString(format: .yearDate)
        }
        self.populatePosterImage(with: movie.posterPath)
        self.updateFavoriteButton()
    }
    
    private func populatePosterImage(with path: String?) {
        
        guard let pathString = path else {
            DDLogError("Can't get poster Path")
            self.setupPosterPlaceholder()
            return
        }
        
        guard let url = URLFactory.posterRequestURL(pathString) else {
            DDLogError("Can't get poster URL")
            self.setupPosterPlaceholder()
            return
        }
        
        ImageLoader.shared.getImageData(url) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.posterImageView?.image = UIImage(data: data)
                }
            case .failure(let error):
                self.setupPosterPlaceholder()
                DDLogError("Can't get contact image data: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupPosterPlaceholder() {
        DispatchQueue.main.async {
            if let placeholderImage = UIImage(named: "posterPlaceholder") {
                self.posterImageView?.image = placeholderImage
            }
        }
    }
    
    private func updateFavoriteButton() {
        guard let movie = self.movieData else { return }
        let buttonImage: UIImage? = movie.favorite ? UIImage(named: "starFavorited") : UIImage(named: "star")
        if let image = buttonImage {
            DispatchQueue.main.async {
                self.favoriteButton.setImage(image, for: .normal)
            }
        }
    }
}

extension MovieTableViewCell: MovieFavoriteDelegate {
    func favoriteStatusUpdated() {
        self.updateFavoriteButton()
    }
}

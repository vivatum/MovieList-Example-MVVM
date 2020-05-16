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
    
    private var isFavorite = false
    
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
        guard let movie = self.movieData else { return }
        FavoritesMovieService.shared.updateFavoriteStatus(for: movie.id)
        self.isFavorite.toggle()
        self.updateFavoriteButton()
    }
    
    // MARK: - Cell content
    
    private func setupCell() {
        self.posterImageView.roundCorners(10)
        self.titleLabel.textColor = AppColorScheme.movieTitle
        self.subtitleLabel.textColor = AppColorScheme.movieSubtitle
        self.isFavorite = false
        self.updateFavoriteButton()
        
        if let placeholderImage = UIImage(named: "posterPlaceholder") {
            self.posterImageView?.image = placeholderImage
        }
    }
    
    private func populateCellContent() {
        guard let movie = self.movieData else { return }
        self.titleLabel.text = movie.title
        self.subtitleLabel.text = movie.releaseDate.toString(format: .yearDate)
        self.populatePosterImage(with: movie.posterPath)
        self.checkFavoriteStatus()
    }
    
    private func populatePosterImage(with path: String) {
        
        guard let url = URLFactory.posterRequestURL(path) else {
            DDLogError("Can't get poster URL")
            return
        }
        
        ImageLoader.shared.getImageData(url) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.posterImageView?.image = UIImage(data: data)
                }
            case .failure(let error):
                DDLogError("Can't get contact image data: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateFavoriteButton() {
        let buttonImage: UIImage? = self.isFavorite ? UIImage(named: "starFavorited") : UIImage(named: "star")
        if let image = buttonImage {
            DispatchQueue.main.async {
                self.favoriteButton.setImage(image, for: .normal)
            }
        }
    }
    
    private func checkFavoriteStatus() {
        guard let movie = self.movieData else { return }
        FavoritesMovieService.shared.isMovieFavorite(movie.id) { result in
            switch result {
            case .success(let status):
                self.isFavorite = status
                self.updateFavoriteButton()
            case .failure(let error):
                DDLogError(error.localizedDescription)
            }
        }
    }
    
}

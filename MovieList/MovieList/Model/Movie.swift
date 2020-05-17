//
//  Movie.swift
//  MovieList
//
//  Created by Vivatum on 16/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import Foundation
import CocoaLumberjack

protocol MovieFavoriteDelegate: class {
    func favoriteStatusUpdated()
}

protocol MovieDetailDelegate: class {
    func favoriteStatusUpdated()
}

final class Movie: Decodable {
    
    let id: Int
    let title: String?
    let posterPath: String?
    let releaseDate: Date?
    let overview: String?
    let vote: Double?
    
    var favorite: Bool = false {
        didSet {
            self.delegate?.favoriteStatusUpdated()
            self.detailDelegate?.favoriteStatusUpdated()
        }
    }
    
    weak var delegate: MovieFavoriteDelegate?
    weak var detailDelegate: MovieDetailDelegate?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case overview
        case vote = "vote_average"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String?.self, forKey: .title)
        posterPath = try values.decode(String?.self, forKey: .posterPath)
        overview = try values.decode(String?.self, forKey: .overview)
        vote = try values.decode(Double?.self, forKey: .vote)
        
        do {
            let releaseDateString = try values.decode(String?.self, forKey: .releaseDate)
            if let date = releaseDateString {
                releaseDate = date.toDate(.reverseDate)
            } else {
                releaseDate = nil
            }
        } catch {
            releaseDate = nil
        }
        
        self.getFavoriteStatus()
    }
    
    
    public func getFavoriteStatus() {
        FavoritesMovieService.shared.isMovieFavorite(id) { [weak self] result in
            switch result {
            case .success(let status):
                self?.favorite = status
            case .failure(let error):
                DDLogError(error.localizedDescription)
            }
        }
    }
    
    public func changeFavoriteStatus() {
        FavoritesMovieService.shared.updateFavoriteStatus(for: self.id) { [weak self] result in
            switch result {
            case .success(let status):
                self?.favorite = status
            case .failure(let error):
                DDLogError(error.localizedDescription)
            }
        }
    }
}

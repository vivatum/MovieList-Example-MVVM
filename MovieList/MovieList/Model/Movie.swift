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

final class Movie: Decodable {
    
    let id: Int
    let title: String
    let posterPath: String
    let releaseDate: Date
    let overview: String
    let vote: Double
    
    var favorite: Bool = false {
        didSet {
            self.delegate?.favoriteStatusUpdated()
        }
    }
    
    weak var delegate: MovieFavoriteDelegate?
    
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
        title = try values.decode(String.self, forKey: .title)
        posterPath = try values.decode(String.self, forKey: .posterPath)
        overview = try values.decode(String.self, forKey: .overview)
        vote = try values.decode(Double.self, forKey: .vote)
        
        let releaseDateString = try values.decode(String.self, forKey: .releaseDate)
        if let date = releaseDateString.toDate(.reverseDate) {
            releaseDate = date
        } else {
            let errorMessage = "Can't convert String to Date for movie id: \(id)"
            let errorContext = DecodingError.Context(codingPath: [CodingKeys.releaseDate], debugDescription: errorMessage)
            DDLogError(errorMessage)
            throw DecodingError.dataCorrupted(errorContext)
        }
        
        self.checkFavoriteStatus()
    }
    
    
    private func checkFavoriteStatus() {
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
        FavoritesMovieService.shared.updateFavoriteStatus(for: self.id)
        self.favorite.toggle()
    }
}

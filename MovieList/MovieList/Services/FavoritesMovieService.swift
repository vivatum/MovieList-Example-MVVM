//
//  FavoritesMovieService.swift
//  MovieList
//
//  Created by Vivatum on 16/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import Foundation
import RealmSwift
import CocoaLumberjack

protocol FavoritesMovieProtocol: class {
    func updateFavoriteStatus(for movieId: Int, _ closure: @escaping ((Result<Bool, ActionError>) -> Void))
    func isMovieFavorite(_ movieId: Int, _ closure: @escaping ((Result<Bool, ActionError>) -> Void))
}

final class FavoritesMovieService: FavoritesMovieProtocol {
    
    static let shared = FavoritesMovieService()
    private init(){}
    
    func updateFavoriteStatus(for movieId: Int, _ closure: @escaping ((Result<Bool, ActionError>) -> Void)) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    if let _favorite = realm.object(ofType: FavoriteMovie.self, forPrimaryKey: movieId) {
                        try realm.write {
                            DDLogInfo("Realm: deleting Favorite id \(_favorite.id)")
                            realm.delete(_favorite)
                            closure(.success(false))
                        }
                    }
                    else {
                        try realm.write {
                            realm.add(FavoriteMovie(id: movieId))
                            DDLogInfo("Realm: New Favorite id \(movieId) added")
                            closure(.success(true))
                        }
                    }
                }
                catch let error {
                    let errorMessage = "Realm: Can't change Favorite status for Movie id \(movieId): \(error.localizedDescription)"
                    DDLogError(errorMessage)
                    closure(.failure(ActionError.dataBase(errorMessage)))
                }
            }
        }
    }
    
    func isMovieFavorite(_ movieId: Int, _ closure: @escaping ((Result<Bool, ActionError>) -> Void)) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    if let _ = realm.object(ofType: FavoriteMovie.self, forPrimaryKey: movieId) {
                        closure(.success(true))
                    } else {
                        closure(.success(false))
                    }
                }
                catch let error {
                    let errorMessage = "Realm: Can't get info about Favorite id \(movieId): \(error.localizedDescription)"
                    DDLogError(errorMessage)
                    closure(.failure(ActionError.dataBase(errorMessage)))
                }
            }
        }
    }
}

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
    func addFavorite(_ movieId: Int)
    func removeFavorite(_ movieId: Int)
    func isMovieFavorite(_ movieId: Int, _ closure: @escaping ((Result<Bool, ActionError>) -> Void))
}

final class FavoritesMovieService: FavoritesMovieProtocol {
    
    static let shared = FavoritesMovieService()
    private init(){}
    
    func addFavorite(_ movieId: Int) {
        let favorite = FavoriteMovie(id: movieId)
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(favorite)
                        DDLogInfo("Realm: New Favorite id \(movieId) added")
                    }
                }
                catch let error {
                    DDLogError("Realm: Can't add New Favorite id \(movieId): \(error.localizedDescription)")
                }
            }
        }
    }
    
    func removeFavorite(_ movieId: Int) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    guard let _favorite = realm.object(ofType: FavoriteMovie.self, forPrimaryKey: movieId) else {
                        DDLogError("Realm: Favorite id does not exist: \(movieId)")
                        return
                    }
                    try realm.write {
                        realm.delete(_favorite)
                        DDLogInfo("Realm: Favorite id \(_favorite.id) removed")
                    }
                }
                catch let error {
                    DDLogError("Realm: Can't remove Favorite id \(movieId): \(error.localizedDescription)")
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
                        DDLogInfo("Realm: Movie id \(movieId) is not favorited")
                        closure(.success(true))
                    } else {
                        DDLogInfo("Realm: Movie id \(movieId) is NOT favorited")
                        closure(.success(false))
                    }
                }
                catch let error {
                    let errorMessage = "Realm: Can't info about Favorite id \(movieId): \(error.localizedDescription)"
                    DDLogError(errorMessage)
                    closure(.failure(ActionError.dataBase(errorMessage)))
                }
            }
        }
    }
}

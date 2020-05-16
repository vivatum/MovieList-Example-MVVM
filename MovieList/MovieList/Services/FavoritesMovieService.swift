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
    func updateFavoriteStatus(for movieId: Int)
    func isMovieFavorite(_ movieId: Int, _ closure: @escaping ((Result<Bool, ActionError>) -> Void))
}

final class FavoritesMovieService: FavoritesMovieProtocol {
    
    static let shared = FavoritesMovieService()
    private init(){}
    
    func updateFavoriteStatus(for movieId: Int) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    if let _favorite = realm.object(ofType: FavoriteMovie.self, forPrimaryKey: movieId) {
                        try realm.write {
                            DDLogInfo("Realm: deleting Favorite id \(_favorite.id)")
                            realm.delete(_favorite)
                        }
                    }
                    else {
                        try realm.write {
                            realm.add(FavoriteMovie(id: movieId))
                            DDLogInfo("Realm: New Favorite id \(movieId) added")
                        }
                    }
                }
                catch let error {
                    DDLogError("Realm: Can't remove Favorite id \(movieId): \(error.localizedDescription)")
                }
            }
        }
    }
    
    // TODO: clean
//    func addFavorite(_ movieId: Int) {
//        let favorite = FavoriteMovie(id: movieId)
//        DispatchQueue.global(qos: .background).async {
//            autoreleasepool {
//                do {
//                    let realm = try Realm()
//                    try realm.write {
//                        realm.add(favorite)
//                        DDLogInfo("Realm: New Favorite id \(movieId) added")
//                    }
//                }
//                catch let error {
//                    DDLogError("Realm: Can't add New Favorite id \(movieId): \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//    func removeFavorite(_ movieId: Int) {
//        DispatchQueue.global(qos: .background).async {
//            autoreleasepool {
//                do {
//                    let realm = try Realm()
//                    guard let _favorite = realm.object(ofType: FavoriteMovie.self, forPrimaryKey: movieId) else {
//                        DDLogError("Realm: Favorite id does not exist: \(movieId)")
//                        return
//                    }
//                    try realm.write {
//                        realm.delete(_favorite)
//                        DDLogInfo("Realm: Favorite id \(_favorite.id) removed")
//                    }
//                }
//                catch let error {
//                    DDLogError("Realm: Can't remove Favorite id \(movieId): \(error.localizedDescription)")
//                }
//            }
//        }
//    }
    
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

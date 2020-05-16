//
//  FavoriteMovie.swift
//  MovieList
//
//  Created by Vivatum on 16/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import Foundation
import RealmSwift

final class FavoriteMovie: Object {
    @objc dynamic var id: Int = Int.min
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int) {
        self.init()
        self.id = id
    }
}

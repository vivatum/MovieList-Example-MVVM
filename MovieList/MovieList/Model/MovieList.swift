//
//  MovieList.swift
//  MovieList
//
//  Created by Vivatum on 16/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import Foundation

final class MovieList: Decodable {
    
    var results: [Movie]
    var page: Int
    var totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case results
        case page
        case totalPages = "total_pages"
    }
    
    init() {
        results = [Movie]()
        page = 0
        totalPages = 1
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try values.decode([Movie].self, forKey: .results)
        self.page = try values.decode(Int.self, forKey: .page)
        self.totalPages = try values.decode(Int.self, forKey: .totalPages)
    }
}


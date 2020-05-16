//
//  MovieList.swift
//  MovieList
//
//  Created by Vivatum on 16/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import Foundation

struct MovieList {
    let results: [Movie]
    let page: Int
    let totalPages: Int
}

extension MovieList: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case results
        case page
        case totalPages = "total_pages"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decode([Movie].self, forKey: .results)
        page = try values.decode(Int.self, forKey: .page)
        totalPages = try values.decode(Int.self, forKey: .totalPages)
    }
}

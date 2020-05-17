//
//  URLFactory.swift
//  MovieList
//
//  Created by Vivatum on 16/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import Foundation

struct URLFactory {
    
    enum URLComponent: String {
        case apiKey = "?api_key=40bdbf8af85f8fea90999afee97574c4"
        case moviePlayNow = "https://api.themoviedb.org/3/movie/now_playing"
        case requestPage = "&page="
        case moviePoster = "https://image.tmdb.org/t/p/w500/"
        case search = "https://api.themoviedb.org/3/search/movie"
        case searchQuery = "&query="
    }
    
    
    static func moviePlayNowRequestURL(_ page: Int) -> URL? {
        
        let urlString = URLComponent.moviePlayNow.rawValue +
            URLComponent.apiKey.rawValue +
            URLComponent.requestPage.rawValue +
            String(describing: page)
        
        return URL(string: urlString)
    }
    
    
    static func posterRequestURL(_ imagePath: String) -> URL? {
        let urlString = URLComponent.moviePoster.rawValue + imagePath
        return URL(string: urlString)
    }
    
    static func searchRequestURLWithPage(_ searchText: String, _ page: Int) -> URL? {
        let urlString = URLComponent.search.rawValue +
            URLComponent.apiKey.rawValue +
            URLComponent.searchQuery.rawValue +
            searchText.searchQuery +
            URLComponent.requestPage.rawValue +
            String(describing: page)
        
        return URL(string: urlString)
    }
    
}

//
//  MovieRequestHandler.swift
//  MovieList
//
//  Created by Vivatum on 16/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import Foundation
import CocoaLumberjack

class MovieRequestHandler {
    
    func parseMovieData(_ responseData: Data, completion: @escaping (Result<MovieList, ActionError>) -> Void) {
        let decoder = JSONDecoder()
        DispatchQueue.global(qos: .background).async(execute: {
            do {
                let movieList = try decoder.decode(MovieList.self, from: responseData)
                completion(.success(movieList))
                DDLogInfo("Movie List parsed successfully")
            } catch {
                let errorMessage = "Can't parse Movie List: \(error)"
                DDLogError(errorMessage)
                completion(.failure(.parser(errorMessage)))
            }
        })
    }
}

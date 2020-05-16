//
//  MovieFetchService.swift
//  MovieList
//
//  Created by Vivatum on 16/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import Foundation
import CocoaLumberjack

protocol MovieFetchProtocol: class {
    func fetchMovieList(by url: URL, _ completion: @escaping (Result<MovieList, ActionError>) -> Void)
}

final class MovieFetchService: MovieRequestHandler, MovieFetchProtocol {
    
    static let shared = MovieFetchService()
    private override init() {}
    
    var task: URLSessionTask?
    
    func fetchMovieList(by url: URL, _ completion: @escaping (Result<MovieList, ActionError>) -> Void) {
        
        guard Network.isReachable else {
            let errorMessage = "Can't load Data: Network unreachable!"
            DDLogError(errorMessage)
            return completion(.failure(.network(errorMessage)))
        }
        
        self.cancelFetchMovie()
        
        task = RequestService().loadData(url: url) { result in
            switch result {
            case .success(let data):
                self.parseMovieData(data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func cancelFetchMovie() {
        guard let currentTask = task else { return }
        currentTask.cancel()
        task = nil
    }
}

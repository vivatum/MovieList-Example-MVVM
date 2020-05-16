//
//  MovieListViewModel.swift
//  MovieList
//
//  Created by Vivatum on 16/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import Foundation
import CocoaLumberjack


final class MovieListViewModel {
    
    weak var dataSource: MovieListDataSource?
    weak var movieService: MovieFetchProtocol?
        
    private var moviePlayNow = [Movie]()
    private var movieSearch = [Movie]()
    private var currentCollection: [Movie]
    
    var stopProgress: (() -> Void)?
    var showMovieDetails: ((Movie) -> Void)?
    var onErrorHandling: ((ActionError?) -> Void)?
    
    var selectedIndexPath: IndexPath? {
        didSet {
            //               if let selectedRecord = getRecordByIndexPath(selectedIndexPath),
            //                   let details = getRecordDetails(selectedRecord) {
            //                   self.showRecordDetails?(details)
            //               }
        }
    }
    
    init(dataSource: MovieListDataSource?, fetchService: MovieFetchProtocol = MovieFetchService.shared) {
        self.currentCollection = moviePlayNow
        self.dataSource = dataSource
        self.movieService = fetchService
    }
    
    // MARK: - Load Movie list
    
    public func updateMovieList() {
        
        guard let service = self.movieService else {
            let errorMessage = "Missing Movie service"
            DDLogError(errorMessage)
            self.onErrorHandling?(.custom(errorMessage))
            return
        }
        
        // TODO: page???
        guard let requestUrl = URLFactory.moviePlayNowRequestURL(1) else {
            let errorMessage = "Can't get request URL"
            DDLogError(errorMessage)
            self.onErrorHandling?(.custom(errorMessage))
            return
        }
        
        service.fetchMovieList(by: requestUrl) { result in
            switch result {
            case .success(let movieList):
                self.stopProgress?()
                self.moviePlayNow.append(contentsOf: movieList.results)
                
                // TODO: optimization??
                self.currentCollection = self.moviePlayNow
                self.dataSource?.data.value = self.currentCollection
                
                
                DDLogInfo("Movie List updated")
            case .failure(let error):
                self.onErrorHandling?(error)
            }
        }
        
    }
    
    
    
    
}

//
//  MovieListViewModel.swift
//  MovieList
//
//  Created by Vivatum on 16/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import Foundation
import CocoaLumberjack

protocol MovieViewModelDelegate: class {
    func movieListUpdated()
    func showMovieDetails(_ movie: Movie)
    func errorHandling(_ error: ActionError?)
}


final class MovieListViewModel {
    
    weak var dataSource: MovieListDataSource?
    weak var movieService: MovieFetchProtocol?
    private weak var delegate: MovieViewModelDelegate?
    
    private var playingNowList = MovieList()
    private var searchResultsList = MovieList()
    
    
    enum ViewState {
        case playingNow
        case searchResults
    }
    
    // TODO: did set
    var currentState: ViewState = .playingNow
    
    var currentList: MovieList {
        switch self.currentState {
        case .playingNow:
            return self.playingNowList
        case .searchResults:
            return self.searchResultsList
        }
    }
    
    
    var selectedIndexPath: IndexPath? {
        didSet {
            //               if let selectedRecord = getRecordByIndexPath(selectedIndexPath),
            //                   let details = getRecordDetails(selectedRecord) {
            //                   self.showRecordDetails?(details)
            //               }
        }
    }
    
    init(dataSource: MovieListDataSource?,
         fetchService: MovieFetchProtocol = MovieFetchService.shared,
         delegate: MovieViewModelDelegate) {
        self.dataSource = dataSource
        self.movieService = fetchService
        self.delegate = delegate
    }
    
    
    // MARK: - Load Movie list
    
    public func updateMovieList() {
        
        guard let service = self.movieService else {
            let errorMessage = "Missing Movie service"
            DDLogError(errorMessage)
            self.delegate?.errorHandling(.custom(errorMessage))
            return
        }
        
        guard currentList.page < currentList.totalPages else {
            DDLogInfo("No more results for current list")
            return
        }
        
        let requestPage = currentList.page + 1
        
        guard let requestUrl = URLFactory.moviePlayNowRequestURL(requestPage) else {
            let errorMessage = "Can't get request URL"
            DDLogError(errorMessage)
            self.delegate?.errorHandling(.custom(errorMessage))
            return
        }
        
        service.fetchMovieList(by: requestUrl) { result in
            switch result {
            case .success(let movieList):
                
                self.currentList.page = movieList.page
                self.currentList.totalPages = movieList.totalPages
                self.currentList.results.append(contentsOf: movieList.results)
                
                self.dataSource?.data = self.currentList.results
                self.delegate?.movieListUpdated()
                DDLogInfo("Movie List updated")
                
            case .failure(let error):
                self.delegate?.errorHandling(error)
            }
        }
    }
    
}


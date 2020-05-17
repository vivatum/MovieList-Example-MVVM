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


final class MovieListViewModel: NSObject {
    
    weak var dataSource: MovieListDataSource?
    weak var movieService: MovieFetchProtocol?
    private weak var delegate: MovieViewModelDelegate?
    
    private var playingNowList = MovieList()
    private var searchResultsList = MovieList()
    
    private var searchText: String = "" {
        didSet {
            self.searchResultsList = MovieList()
            self.fetchSearchResult()
        }
    }
    
    enum ViewState {
        case playingNow
        case searchResults
    }
    
    var currentState: ViewState = .playingNow {
        didSet {
            self.searchText = ""
            self.dataSource?.data = self.currentList.results
            self.delegate?.movieListUpdated()
        }
    }
    
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
            self.handleSelectedIndexPath(selectedIndexPath)
        }
    }
    
    init(dataSource: MovieListDataSource?,
         fetchService: MovieFetchProtocol = MovieFetchService.shared,
         delegate: MovieViewModelDelegate) {
        self.dataSource = dataSource
        self.movieService = fetchService
        self.delegate = delegate
    }
    
    
    // MARK: - Fetch Movie list
    
    public func fetchMovieList() {
        switch self.currentState {
        case .playingNow:
            self.fetchPlayingNow()
        case .searchResults:
            self.fetchSearchResult()
        }
    }
    
    private func fetchPlayingNow() {
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
        
        self.updateCurrentCollection(with: requestUrl)
    }
    
    private func fetchSearchResult() {
       guard !self.searchText.isEmpty else { return }
        
        guard currentList.page < currentList.totalPages else {
            DDLogInfo("No more results for current list")
            return
        }
        
        let requestPage = currentList.page + 1
        
        guard let requestUrl = URLFactory.searchRequestURLWithPage(self.searchText, requestPage) else {
            let errorMessage = "Can't get request URL"
            DDLogError(errorMessage)
            self.delegate?.errorHandling(.badRequest(errorMessage))
            return
        }
        
        self.updateCurrentCollection(with: requestUrl)
    }
    
    
    private func updateCurrentCollection(with url: URL) {
        
       guard let service = self.movieService else {
            let errorMessage = "Missing Movie service"
            DDLogError(errorMessage)
            self.delegate?.errorHandling(.custom(errorMessage))
            return
        }
        
        service.fetchMovieList(by: url) { result in
            switch result {
            case .success(let movieList):
                
                self.currentList.page = movieList.page
                self.currentList.totalPages = movieList.totalPages
                self.currentList.results.append(contentsOf: movieList.results)
                
                self.dataSource?.data = self.currentList.results
                self.delegate?.movieListUpdated()
                DDLogInfo("Movie List updated")
                
            case .failure(let error):
                switch error {
                case .internet:
                    self.delegate?.errorHandling(error)
                default:
                    DDLogError("FetchMovieList errror: \(error)")
                }
            }
        }
    }
    
    private func handleSelectedIndexPath(_ indexPath: IndexPath?) {
        guard let selected = indexPath else { return }
        let movie = self.currentList.results[selected.row]
        self.delegate?.showMovieDetails(movie)
    }
}

extension MovieListViewModel: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }
        self.searchText = text
    }
}

extension MovieListViewModel: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            searchController.searchBar.text = nil
            self.currentState = .searchResults
        }
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.currentState = .playingNow
        DispatchQueue.main.async {
            searchController.searchBar.resignFirstResponder()
        }
    }
}

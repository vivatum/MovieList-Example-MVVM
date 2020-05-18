//
//  MovieListViewController.swift
//  MovieList
//
//  Created by Vivatum on 15/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import UIKit
import CocoaLumberjack

final class MovieListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let activityIndicator = UIActivityIndicatorView()
    private var noDataView: NoDataView?
    private let navTitle = "movie.list.title".localized
    
    private var searchController: UISearchController? = nil
    
    enum SegueName: String {
        case movieDetails = "MovieDetailsSegue"
    }
    
    let dataSource = MovieListDataSource()
    lazy var viewModel = MovieListViewModel(dataSource: dataSource, delegate: self)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.navTitle
        self.setupTableView()
        self.setupSearchController()
        self.updateMoviewCollection()
    }
    

    // MARK: - Setup View
    
    private func setupTableView() {
        self.noDataView = NoDataView()
        tableView.dataSource = self.dataSource
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.backgroundView = self.noDataView
        tableView.keyboardDismissMode = .interactive
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - setup SearchController
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self.viewModel
        searchController?.delegate = self.viewModel
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.placeholder = "movie.list.search".localized
        definesPresentationContext = true
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController?.searchBar
        }
    }
    
    
    // MARK: - Update Movie collection
    
    private func updateMoviewCollection() {
        DDLogInfo("Start updating Movie collection")
        self.showTitleProgress()
        self.noDataView?.message = .loading
        self.viewModel.fetchMovieList()
    }
    
    
    // MARK: - Progress Activities
    
    private func showTitleProgress() {
        if #available(iOS 11.0, *) {
            DispatchQueue.main.async {
                self.navigationItem.titleView = self.activityIndicator
                self.activityIndicator.startAnimating()
            }
        }
    }
    
    private func hideTitleProgress() {
        if #available(iOS 11.0, *) {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.navigationItem.titleView = nil
                self.title = self.navTitle
            }
        }
    }
}



extension MovieListViewController: MovieViewModelDelegate {
    
    func movieListUpdated(_ noDataMessage: NoDataMessage) {
        DispatchQueue.main.async {
            self.hideTitleProgress()
            self.noDataView?.message = noDataMessage
            self.tableView.reloadData()
        }
    }
    
    func showMovieDetails(_ movie: Movie) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: SegueName.movieDetails.rawValue, sender: movie)
        }
    }
    
    func errorHandling(_ error: ActionError?, _ noDataMessage: NoDataMessage) {
        DDLogError("Error: \(String(describing: error?.localizedDescription))")
        
        DispatchQueue.main.async {
            self.hideTitleProgress()
            
            if let err = error {
                DDLogError("ActionError content: \(err)")
                AlertHelper.showErrorAlert(err.alertContent)
            }
            
            self.noDataView?.message = noDataMessage
        }
    }
    
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueName.movieDetails.rawValue {
            
            guard let movie = sender as? Movie else {
                DDLogError("Can't get Movie from sender")
                return
            }
            
            if let controller = segue.destination as? MovieDetailsViewController {
                controller.movieData = movie
                DDLogInfo("Go to MovieDetailsViewController")
            }
        }
    }
}

extension MovieListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow {
            self.viewModel.selectedIndexPath = indexPath
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MovieListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            self.viewModel.fetchMovieList()
        }
    }
    
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= (self.viewModel.currentList.results.count - 1)
    }
}

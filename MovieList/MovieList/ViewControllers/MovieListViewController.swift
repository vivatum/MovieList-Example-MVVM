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
    private let navTitle = "movie.list.playing.now".localized
    
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
//        searchController.isActive = true
        navigationItem.titleView = searchController?.searchBar
        definesPresentationContext = true
        
    }
    
    
    
    // MARK: - NoDataView Message
    // TODO: ???
    private func updtateNoDataMessage(_ isDataEmpty: Bool?) {
        self.noDataView?.message = (isDataEmpty ?? true) ? .noDataFetched : .noMessage
    }
    
    
    // MARK: - Update Movie collection
    
    private func updateMoviewCollection() {
        DDLogInfo("Start updating Movie collection")
        self.showTitleProgress()
        self.noDataView?.message = .loading
        self.viewModel.updateMovieList()
    }
    
    
    // MARK: - Progress Activities
    
    private func showTitleProgress() {
        DispatchQueue.main.async {
            //self.navigationItem.titleView = self.activityIndicator
            self.activityIndicator.startAnimating()
        }
    }
    
    private func hideTitleProgress() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            //self.navigationItem.titleView = nil
            self.title = self.navTitle
        }
    }
}



extension MovieListViewController: MovieViewModelDelegate {
    
    func movieListUpdated() {
        DispatchQueue.main.async {
            self.hideTitleProgress()
            self.tableView.reloadData()
        }
    }
    
    func showMovieDetails(_ movie: Movie) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: SegueName.movieDetails.rawValue, sender: movie)
        }
    }
    
    func errorHandling(_ error: ActionError?) {
        DDLogError("Error: \(String(describing: error?.localizedDescription))")
        
        DispatchQueue.main.async {
            self.hideTitleProgress()
            
            if let err = error {
                DDLogError("ActionError content: \(err)")
                AlertHelper.showErrorAlert(err.alertContent)
            }
            
            // TODO:
//            if let viewData = self.dataSource.data.value {
//                self?.updtateNoDataMessage(viewData.isEmpty)
//            }
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
            self.viewModel.updateMovieList()
        }
    }
    
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= (viewModel.currentList.results.count - 1)
    }
}

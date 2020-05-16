//
//  MovieListViewController.swift
//  MovieList
//
//  Created by Vivatum on 15/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import UIKit
import CocoaLumberjack

class MovieListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let activityIndicator = UIActivityIndicatorView()
    private var noDataView: NoDataView?
    private let navTitle = "movie.list.playing.now".localized
    
    enum SegueName: String {
        case movieDetails = "MovieDetailsSegue"
    }
    
    let dataSource = MovieListDataSource()
    lazy var viewModel = MovieListViewModel(dataSource: dataSource)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.navTitle
        self.setupTableView()
        self.setupViewModel()
        self.updateMoviewCollection()
    }
    

    // MARK: - Setup View
    
    private func setupTableView() {
        self.noDataView = NoDataView()
        tableView.dataSource = self.dataSource
        tableView.delegate = self
        tableView.backgroundView = self.noDataView
        tableView.tableFooterView = UIView()
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
    
    
    // MARK: - Setup ViewModel
    
    private func setupViewModel() {
        
        self.dataSource.data.bindAndFire { [weak self] data in
            DispatchQueue.main.async {
                self?.updtateNoDataMessage(data.isEmpty)
                self?.tableView.reloadData()
            }
        }
        
        self.viewModel.onErrorHandling = { [weak self] error in
            DDLogError("Error: \(String(describing: error?.localizedDescription))")
            
            DispatchQueue.main.async {
                self?.hideTitleProgress()
                
                if let err = error {
                    DDLogError("ActionError content: \(err)")
                    AlertHelper.showErrorAlert(err.alertContent)
                }
                
                if let viewData = self?.dataSource.data.value {
                    self?.updtateNoDataMessage(viewData.isEmpty)
                }
            }
        }
        
        self.viewModel.stopProgress = { [weak self] in
            DDLogInfo("Hide progress elements")
            self?.hideTitleProgress()
        }
        
        
//        self.viewModel.showContactDetails = { [weak self] contact in
//            DDLogInfo("Show contact details")
//            self?.hideAllProgressActivities()
//            DispatchQueue.main.async {
//                self?.performSegue(withIdentifier: "showDetail", sender: contact)
//            }
//        }
    }
    
    
    // MARK: - Progress Activities
    
    private func showTitleProgress() {
        DispatchQueue.main.async {
            self.navigationItem.titleView = self.activityIndicator
            self.activityIndicator.startAnimating()
        }
    }
    
    private func hideTitleProgress() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.navigationItem.titleView = nil
            self.title = self.navTitle
        }
    }
}


extension MovieListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO:
//        if let indexPath = tableView.indexPathForSelectedRow {
//            self.viewModel.selectedIndexPath = indexPath
//        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

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
    
    enum SegueName: String {
        case movieDetails = "MovieDetailsSegue"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        if let url = URLFactory.moviePlayNowRequestURL(1) {
//            MovieFetchService.shared.fetchMovieList(by: url) { result in
//                switch result {
//                case .success(let list):
//                    print(list.results.first!)
//                case .failure(let action):
//                    print(action.localizedDescription)
//                }
//            }
//        }
        
    }
    

}

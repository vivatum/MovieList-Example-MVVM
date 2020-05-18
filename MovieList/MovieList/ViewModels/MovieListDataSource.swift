//
//  MovieListDataSource.swift
//  MovieList
//
//  Created by Vivatum on 16/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import UIKit

final class MovieListDataSource: NSObject, UITableViewDataSource {
    
    public var data: [Movie] = []
    
    private enum CellIdentifiers {
      static let movie = "MovieCell"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.movie, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        cell.movieData = data[indexPath.row]
        return cell
    }
}


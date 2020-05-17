//
//  NoDataMessage.swift
//  MovieList
//
//  Created by Vivatum on 15/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import Foundation

enum NoDataMessage {
    case noDataFetched
    case noMessage
    case loading
    case emptySearch
    case readyForSearch
    
    var message: String {
        switch self {
        case .noDataFetched:
            return "data.no.fetched".localized
        case .noMessage:
            return ""
        case .loading:
            return "data.no.loading".localized
        case .emptySearch:
            return "data.no.empty.search".localized
        case .readyForSearch:
            return "data.no.ready.search".localized
        }
    }
}

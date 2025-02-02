//
//  ActionError.swift
//  MovieList
//
//  Created by Vivatum on 15/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import Foundation

enum ActionError: Error {
    
    case internet(_ message: String)
    case badRequest(_ message: String)
    case network(_ message: String)
    case backend(_ message: String)
    case parser(_ message: String)
    case dataBase(_ message: String)
    case custom(_ message: String)
    
    var alertContent: AlertMessage {
        var titleText = ""
        var messageText = ""
        
        switch self {
        case .internet:
            titleText = "error.network.title".localized
            messageText = "error.network.message".localized
        case .backend, .parser, .dataBase, .network, .custom:
            titleText = "error.fetching.data.title".localized
            messageText = "error.fetching.data.message".localized
        case .badRequest:
            titleText = "error.bad.request.title".localized
            messageText = "error.bad.request.message".localized
        }
        
        return AlertMessage(title: titleText, message: messageText)
    }
}

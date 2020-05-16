//
//  RequestFactory.swift
//  MovieList
//
//  Created by Vivatum on 16/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import Foundation

final class RequestFactory {
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
        case PATCH
    }
    
    static func request(method: Method, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}

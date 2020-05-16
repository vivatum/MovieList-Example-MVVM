//
//  RequestService.swift
//  MovieList
//
//  Created by Vivatum on 16/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import Foundation
import CocoaLumberjack

final class RequestService {
    
    func loadData(url: URL, session: URLSession = URLSession(configuration: .default), completion: @escaping (Result<Data, ActionError>) -> Void) -> URLSessionTask? {
        
        let request = RequestFactory.request(method: .GET, url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                completion(.failure(.network("An error occured during request :" + err.localizedDescription)))
                DDLogError("Task request error: \(err.localizedDescription)")
                return
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
        return task
    }
}

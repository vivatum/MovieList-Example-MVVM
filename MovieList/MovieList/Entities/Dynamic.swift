//
//  Dynamic.swift
//  MovieList
//
//  Created by Vivatum on 16/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import Foundation

final class Dynamic<T> {
    
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        bind(listener)
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
}

//
//  StringExtension.swift
//  MovieList
//
//  Created by Vivatum on 15/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import UIKit

extension String {
    
    // MARK: - Localization
    
    var localized: String {
        
        let message = NSLocalizedString(self, comment: "")
        
        if message != self {
            return message
        }
        
        guard let path = Bundle.main.path(forResource: "en", ofType: "lproj") else { return self }
        guard let bundle = Bundle(path: path) else { return self }
        return bundle.localizedString(forKey: self, value: nil, table: nil)
    }
    
    
}


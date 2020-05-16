//
//  DateExtension.swift
//  MovieList
//
//  Created by Vivatum on 15/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(format: DateFormatString) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
}

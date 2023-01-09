//
//  Date+Extension.swift
//  GitHFollowers
//
//  Created by Afir Thes on 13.12.2022.
//

import Foundation

extension Date {
    
    func converToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        return dateFormatter.string(from: self)
    }
}

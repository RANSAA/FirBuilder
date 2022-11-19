//
//  DateFormatter.swift
//  FirBuilder
//
//  Created by PC on 2022/2/14.
//

import Foundation


extension DateFormatter{
    static func dateStringWith(date:Date) ->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
}

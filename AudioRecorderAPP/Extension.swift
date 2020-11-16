//
//  Extensions.swift
//  recorderAPPnew
//
//  Created by user on 2020/10/11.
//

import SwiftUI

extension Date {
    func toString( dateFormat format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
        
    }
}




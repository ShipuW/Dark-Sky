//
//  TimeCoverter.swift
//  Dark Sky
//
//  Created by Shipu Wang on 2/13/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import Foundation

class TimeConverter {
    class func getDateStringFromUTC(time:Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(time))
    
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
    
        return dateFormatter.string(from: date)
    }
}

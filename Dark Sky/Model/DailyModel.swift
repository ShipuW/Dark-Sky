//
//  DailyModel.swift
//  Dark Sky
//
//  Created by Shipu Wang on 2/13/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import UIKit

class DailyModel: BaseModel {
    
    var icon : String?
    var tempHigh : Double?
    var tempLow : Double?
    var summary : String?
    
    
    enum WeatherKeys : Int {
        case KeyIcon, KeyHigh, KeyLow, KeySummary
        func toKey() -> String! {
            switch self {
            case .KeyIcon:
                return "icon"
            case .KeyHigh:
                return "temperatureHigh"
            case .KeyLow:
                return "temperatureLow"
            case .KeySummary:
                return "summary"
            }
        }
    }
    
    
    required init(_ dictionary: Dictionary<String, AnyObject>) {
        
        super.init(dictionary)

        icon = dictionary[WeatherKeys.KeyIcon.toKey()] as? String
        tempHigh = dictionary[WeatherKeys.KeyHigh.toKey()] as? Double
        tempLow = dictionary[WeatherKeys.KeyLow.toKey()] as? Double
        summary = dictionary[WeatherKeys.KeySummary.toKey()] as? String
        
    }
}

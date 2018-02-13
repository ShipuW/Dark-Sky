//
//  BaseModel.swift
//  Dark Sky
//
//  Created by Shipu Wang on 2/12/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import UIKit

class BaseModel {

    var time : Int64?
    
    enum WeatherKeys : Int {
        case KeyTime
        func toKey() -> String! {
            switch self {
            case .KeyTime:
                return "time"
            }
        }
    }
    
    required init(_ dictionary: Dictionary<String, AnyObject>){
        time = dictionary[WeatherKeys.KeyTime.toKey()] as? Int64
    }
    
    class func ArrayFromDict(dict:Dictionary<String, Any>, keyWord:String) -> (Array<Any>) {
        let array = dict[keyWord];
        return self.ArrayFromArray(array: array as! Array<Any>)
        
    }
    
    class func ArrayFromArray(array:Array<Any>) -> (Array<Any>) {
        
        var resArray: Array<AnyObject> = []
        for item in array {
            let dict = item as? Dictionary<String, AnyObject>
            let object = self.objectFromDictionary(dictionary: dict!)
            resArray.append(object)
        }
        return resArray
        
    }
    
    public class func objectFromDictionary(dictionary: Dictionary<String, AnyObject>) -> Self {
        return self.init(dictionary)
    }
    
    
    
}

//
//  NetworkManager.swift
//  Dark Sky
//
//  Created by Shipu Wang on 2/12/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    private let host = "https://api.darksky.net/forecast/"
    private let key = "8beda6d97d57aa96d640ed7a6c2bc79f"
    
    
    typealias CompletionHandler = (_ success:Bool, _ error:Error?, _ responseData:Dictionary<String, Any>?) -> Void
    
    /// singleton
    static let shared: NetworkManager = {
        let instance = NetworkManager()
        // setup code
        return instance
    }()
    
    
    class func GetWeatherAt(latitude:String, longitude:String, completionHandler: @escaping CompletionHandler) -> Void {
        self.shared.GetWeatherData(latitude: latitude, longitude: longitude, completionHandler: completionHandler)
    }
    
    
    // GET Funtions
    
    private func GetWeatherData(latitude:String, longitude:String, completionHandler: @escaping CompletionHandler) {
        Alamofire.request(host + key + "/" + latitude + "," + longitude, method: .get, parameters: nil).responseJSON { (response) in
            
                switch response.result {
                case .success:
                    let jsonResult = response.result.value as! Dictionary<String, Any>
                    completionHandler(true, nil, jsonResult)
                case .failure(let error):
                    completionHandler(false, error, nil)
                }
            
            }
    }
    
}

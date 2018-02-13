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
    
    
    typealias CompletionHandler = (_ success:Bool, _ responseData:Any?) -> Void
    
    /// singleton
    static let shared = NetworkManager()
    
    class func GetWeatherAt(latitude:String, longitude:String, completionHandler: @escaping CompletionHandler) -> Void {
        self.shared.GetWeatherData(latitude: latitude, longitude: longitude, completionHandler: completionHandler)
    }
    
    
    // GET Funtions
    
    private func GetWeatherData(latitude:String, longitude:String, completionHandler: @escaping CompletionHandler) {
        Alamofire.request(host + key + "/" + latitude + "," + longitude, method: .get, parameters: nil).responseJSON { (response) in
            
                switch response.result {
                case .success:
                    completionHandler(true, response.result.value)
                case .failure(let error):
                    completionHandler(false, error)
                }
            
            }
    }
    
}

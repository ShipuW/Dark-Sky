//
//  LocationManger.swift
//  Dark Sky
//
//  Created by Shipu Wang on 2/13/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject,CLLocationManagerDelegate {
    
    enum LocationErrors: String {
        case denied = "Locations are turned off. Please turn it on in Settings"
        case restricted = "Locations are restricted"
        case notDetermined = "Locations are not determined yet"
        case notFetched = "Unable to fetch location"
        case invalidLocation = "Invalid Location"
        case reverseGeocodingFailed = "Reverse Geocoding Failed"
    }
    
    
    static let sharedInstance: LocationManager = {
        let instance = LocationManager()
        // setup code
        return instance
    }()
    
    
    //Time allowed to fetch the location continuously for accuracy
    private var locationFetchTimeInSeconds = 1.0
    
    typealias LocationClosure = ((_ location:CLLocation?,_ error: NSError?)->Void)
    private var locationCompletionHandler: LocationClosure?

    
    private var locationManager:CLLocationManager?
    var locationAccuracy = kCLLocationAccuracyBest
    
    private var lastLocation:CLLocation?

    
    //MARK:- Private Methods
    private func setupLocationManager() {
        
        //Setting of location manager
        locationManager = nil
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = locationAccuracy
        locationManager?.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
            startPositioning()
        case .notDetermined,.restricted, .denied:
            NSLog("Authoried failed")
            didComplete(location: nil,error: nil)
        }
        
    }
    
    private func startPositioning() {
        self.perform(#selector(sendLocation), with: nil, afterDelay: locationFetchTimeInSeconds)
    }
    
    @objc private func sendLocation() {
        guard let _ = lastLocation else {
            self.didComplete(location: nil,error: NSError(
                domain: self.classForCoder.description(),
                code:Int(CLAuthorizationStatus.denied.rawValue),
                userInfo:
                [NSLocalizedDescriptionKey:LocationErrors.notFetched.rawValue,
                 NSLocalizedFailureReasonErrorKey:LocationErrors.notFetched.rawValue,
                 NSLocalizedRecoverySuggestionErrorKey:LocationErrors.notFetched.rawValue]))
            lastLocation = nil
            return
        }
        self.didComplete(location: lastLocation,error: nil)
        lastLocation = nil
    }
    
    //MARK:- Public Methods
    
    func authorizedAndGetLocation(completionHandler:@escaping LocationClosure){
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager = CLLocationManager()
            locationManager?.requestWhenInUseAuthorization()
        }
        getLocation(completionHandler: completionHandler)
    }
    
    
    
    func getLocation(completionHandler:@escaping LocationClosure) {
        
        //Cancel previous timer
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        locationCompletionHandler = completionHandler
        lastLocation = nil
        self.setupLocationManager()

    }
    
    
    func setFetchTimerForLocation(seconds:Double) {
        locationFetchTimeInSeconds = seconds
    }
    
    
    
    //MARK:- CLLocationManager Delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .authorizedWhenInUse,.authorizedAlways:
            self.locationManager?.startUpdatingLocation()
            startPositioning()

            
        case .denied:
            let deniedError = NSError(
                domain: self.classForCoder.description(),
                code:Int(CLAuthorizationStatus.denied.rawValue),
                userInfo:
                [NSLocalizedDescriptionKey:LocationErrors.denied.rawValue,
                 NSLocalizedFailureReasonErrorKey:LocationErrors.denied.rawValue,
                 NSLocalizedRecoverySuggestionErrorKey:LocationErrors.denied.rawValue])
            
            didComplete(location: nil,error: deniedError)
            
        case .restricted:
            didComplete(location: nil,error: NSError(
                domain: self.classForCoder.description(),
                code:Int(CLAuthorizationStatus.restricted.rawValue),
                userInfo: nil))
        
            break
            
        case .notDetermined:
            self.locationManager?.requestWhenInUseAuthorization()
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        self.didComplete(location: nil, error: error as NSError?)
    }
    
    private func didComplete(location: CLLocation?,error: NSError?) {
        locationManager?.stopUpdatingLocation()
        locationCompletionHandler?(location,error)
        locationManager?.delegate = nil
        locationManager = nil
    }

}

//
//  WeatherTableViewController.swift
//  Dark Sky
//
//  Created by Shipu Wang on 2/12/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import UIKit


class WeatherTableViewController: UITableViewController {

    var weatherArray = [DailyModel]()
    var latitude:String = ""
    var longitude:String = ""
    
    var authorizedLocation:Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.LoadUI()
        self.LoadData()

//        LocationManager.sharedInstance.getLocation { (location, error) in
//            print(location ?? "No location get")
//        }
//        LocationManager.sharedInstance.authorizedLocation()
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func LoadUI() {
        self.title = "Daily Weather"
    }
    
    
    func LoadData() {
        
        if let path = Bundle.main.path(forResource: "DefaultLocations", ofType: "plist") {
            let arrayRoot = NSArray(contentsOfFile: path)
            if let array = arrayRoot {
                let dict = array[0] as! Dictionary<String, Any>
                latitude = dict["latitude"] as! String
                longitude = dict["longitude"] as! String
            }
        }
        
        LocationManager.sharedInstance.getLocation { (location, error) in
            if error == nil {
                self.authorizedLocation = true
                self.latitude = String(describing: location?.coordinate.latitude)
                self.longitude = String(describing: location?.coordinate.longitude)
            } else {
                self.authorizedLocation = false
            }
        }
        self.refreshTableView()
        
    }
    
    

    func refreshTableView() {
        NetworkManager.GetWeatherAt(latitude: latitude, longitude: longitude) { (success, error, dict) in
           
            self.weatherArray = DailyModel.ArrayFromDict(dict: dict!["daily"] as! Dictionary<String, Any>, keyWord: "data") as! [DailyModel]
            
        }
        self.tableView.reloadData()
    }
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

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
    var latitude:String = "";
    var longitude:String = "";
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.LoadData()
        self.LoadUI()
        self.RefreshTableView()
//        LocationManager.sharedInstance.getLocation { (location, error) in
//            print(location ?? "No location get")
//        }
//        LocationManager.sharedInstance.authorizedLocation()
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func LoadData() {
        
        latitude = "34.050493"
        longitude = "-118.459137"
    }
    
    func LoadUI() {
        self.title = "Daily Weather"
    }

    func RefreshTableView() {
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

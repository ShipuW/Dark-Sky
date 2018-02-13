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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RefreshTableView()
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    func LoadUI() {
        self.navigationItem.title = "Daily Weather"
    }

    func RefreshTableView() {
        NetworkManager.GetWeatherAt(latitude: "34.050493", longitude: "-118.459137") { (success, error, dict) in
           
            let array = DailyModel.ArrayFromDict(dict: dict!["daily"] as! Dictionary<String, Any>, keyWord: "data")
            print((array[0] as! DailyModel).time ?? "some")
            
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

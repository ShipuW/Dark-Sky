//
//  WeatherTableViewController.swift
//  Dark Sky
//
//  Created by Shipu Wang on 2/12/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import UIKit

private let reuseID = "WeekWeatherCell"

class WeatherTableViewController: UITableViewController {

    var weatherArray = [DailyModel]()
    var latitude:String = ""
    var longitude:String = ""
    
    var authorizedLocation:Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.LoadUI()
        self.LoadData()
        self.refreshTableView()

    }

    func LoadUI() {
        self.title = "Daily Weather"
        let rightBarButton = UIBarButtonItem(image: UIImage.init(named: "location"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        // Register Cell
        tableView.register(UINib(nibName: reuseID, bundle: Bundle.main), forCellReuseIdentifier: reuseID)
        
        // Init refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: UIControlEvents.valueChanged)
        
    }
    
    @objc func pullToRefresh(_ sender:AnyObject)
    {
        LocationManager.sharedInstance.getLocation { (location, error) in
            if error == nil {
                self.authorizedLocation = true
                if let lat = location?.coordinate.latitude {
                    self.latitude = String(format: "%f", lat)
                }
                if let lon = location?.coordinate.longitude {
                    self.longitude = String(format: "%f", lon)
                }
            } else {
                self.authorizedLocation = false
            }
            self.refreshTableView()
        }
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
                if let lat = location?.coordinate.latitude {
                    self.latitude = String(format: "%f", lat)
                }
                if let lon = location?.coordinate.longitude {
                    self.longitude = String(format: "%f", lon)
                }
            } else {
                self.authorizedLocation = false
            }
            self.refreshTableView()
        }
    }
    
    @objc func rightBarButtonTapped(_ sender:UIBarButtonItem!)
    {
        LocationManager.sharedInstance.authorizedAndGetLocation { (location, error) in
            if error == nil {
                self.authorizedLocation = true
                if let lat = location?.coordinate.latitude {
                    self.latitude = String(format: "%f", lat)
                }
                if let lon = location?.coordinate.longitude {
                    self.longitude = String(format: "%f", lon)
                }
            } else {
                self.authorizedLocation = false
            }
            self.refreshTableView()
        }
    }

    
    
    func refreshTableView() {
        NetworkManager.GetWeatherAt(latitude: latitude, longitude: longitude) { (success, error, dict) in
            if error != nil {
                AlertDisplay.ShowAlert(title: "Error", message: "Please check your network.", controller: self)
                self.refreshControl?.endRefreshing()
                return;
            }
            if let dailyDict = dict!["daily"] {
                self.weatherArray = DailyModel.ArrayFromDict(dict: dailyDict as! Dictionary<String, Any>, keyWord: "data") as! [DailyModel]
                self.tableView.reloadData()
            }
            
            if let errorDict = dict!["error"] {
                print(errorDict)
            }
    
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    
    
    // MARK: - TableView - Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as!WeekWeatherCell
        
        let dailyResult = weatherArray[indexPath.row]
        
        cell.configureForDailyResult(dailyResult)
        
        return cell
    }
    
    // MARK - TableView - Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailVC.dailyModel = weatherArray[indexPath.row]
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}

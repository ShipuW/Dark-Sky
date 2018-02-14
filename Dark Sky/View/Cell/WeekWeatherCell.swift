//
//  WeekWeatherCell.swift
//  Dark Sky
//
//  Created by Shipu Wang on 2/13/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import UIKit

class WeekWeatherCell: UITableViewCell {

    @IBOutlet weak var labelOfDate: UILabel!
    @IBOutlet weak var labelOfHighTemp: UILabel!
    @IBOutlet weak var labelOfLowTemp: UILabel!
    
    var dailyModel:DailyModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureForDailyResult(_ dailyResult: DailyModel){
        
        self.dailyModel = dailyResult
        
        labelOfDate.text = TimeConverter.getDateStringFromUTC(time: (self.dailyModel?.time!)!)

        labelOfHighTemp.text = String(format: "H:%.2f", (self.dailyModel?.tempHigh)!)
        
        labelOfLowTemp.text = String(format: "L:%.2f", (self.dailyModel?.tempLow)!)
        
    }
    
}

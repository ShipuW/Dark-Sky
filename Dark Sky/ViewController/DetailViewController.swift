//
//  DetailViewController.swift
//  Dark Sky
//
//  Created by Shipu Wang on 2/12/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var dailyModel:DailyModel?

    @IBOutlet weak var summaryTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ConfigUI()
    }
    
    private func ConfigUI(){
        self.title = "Summary"
        if let summary = self.dailyModel?.summary {
            summaryTextView.text = summary
        }
    }
    

}

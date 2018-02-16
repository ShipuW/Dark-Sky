//
//  AlertDisplay.swift
//  Dark Sky
//
//  Created by Shipu Wang on 2/16/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import Foundation
import UIKit

class AlertDisplay {
    class func ShowAlert (title:String, message:String?, controller:UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        controller.present(alertController, animated: true, completion: nil)
    }
}

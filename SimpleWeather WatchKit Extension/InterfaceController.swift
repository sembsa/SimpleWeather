//
//  InterfaceController.swift
//  SimpleWeather WatchKit Extension
//
//  Created by Sebastian Trześniewski on 27.08.2015.
//  Copyright © 2015 Sebastian Trześniewski. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var imageWeather: WKInterfaceImage!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func odsiewzPogode() {
        
        let data = NSData(contentsOfURL: NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=Krakow,pl")!)
        
        do {
            let calaPrognoza = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments).valueForKey("weather")
            let pogoda = calaPrognoza?.valueForKey("main") as! String
            print(pogoda)
        } catch {
            print(error)
        }
    }
}

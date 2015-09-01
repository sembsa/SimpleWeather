//
//  InterfaceController.swift
//  SimpleWeather WatchKit Extension
//
//  Created by Sebastian Trześniewski on 27.08.2015.
//  Copyright © 2015 Sebastian Trześniewski. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, NSURLSessionDelegate {

    @IBOutlet var imageWeather: WKInterfaceImage!
    @IBOutlet var opisPogody: WKInterfaceLabel!
    @IBOutlet var temperaturaLabel: WKInterfaceLabel!
    
    var session: NSURLSession?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        sprawdzaniePogody()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func sprawdzaniePogody() {
        var calaPrognoza: AnyObject?
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: sessionConfig)
        session!.dataTaskWithURL(NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=Krakow,pl&lang=pl&APPID=75e621cdfb3c7776e9b43e706b2ab5a3")!) { (data:NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            do {
                calaPrognoza = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                let weather = calaPrognoza!.valueForKeyPath("weather")
                let opisPogodyValue = weather!.objectAtIndex(0).valueForKeyPath("description") as! String
                self.opisPogody.setText(opisPogodyValue)
                //let pogoda = weather!.objectAtIndex(0).valueForKeyPath("icon") as! String
                self.wstawianieObrazka(weather!.objectAtIndex(0).valueForKeyPath("icon") as! String)
                //self.imageWeather.setImageNamed(pogoda)
//                self.session!.dataTaskWithURL(NSURL(string: "http://openweathermap.org/img/w/" + pogoda + ".png")!, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
//                    self.imageWeather.setImageData(NSData(data: data!))
//                }).resume()
                
                let temperaturaPogoda = (calaPrognoza!.valueForKeyPath("main")?.valueForKeyPath("temp") as! Float) / 10
                self.temperaturaLabel.setText(String(format: "%.1f", temperaturaPogoda))
                
            } catch {
                print(error)
            }
            }.resume()
    }
    
    func wstawianieObrazka(images: String) {
        if (UIImage(named: images) != nil) {
            imageWeather.setImageNamed(images)
        } else {
            imageWeather.setImageNamed("brak")
            let dismissAction = WKAlertAction(title: "OK", style: WKAlertActionStyle.Cancel, handler: {})
            self.presentAlertControllerWithTitle("Brak obrazka", message: "Obrazek: \(images)", preferredStyle: WKAlertControllerStyle.Alert, actions: [dismissAction])
            
        }
    }
    

    @IBAction func odsiewzPogode() {
        sprawdzaniePogody()
    }
}

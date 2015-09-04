//
//  InterfaceController.swift
//  SimpleWeather WatchKit Extension
//
//  Created by Sebastian Trześniewski on 27.08.2015.
//  Copyright © 2015 Sebastian Trześniewski. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation


class InterfaceController: WKInterfaceController, NSURLSessionDelegate, CLLocationManagerDelegate {

    @IBOutlet var imageWeather: WKInterfaceImage!
    @IBOutlet var opisPogody: WKInterfaceLabel!
    @IBOutlet var temperaturaLabel: WKInterfaceLabel!
    @IBOutlet var miastoLabel: WKInterfaceLabel!
    @IBOutlet var dataLabel: WKInterfaceLabel!
    
    var session: NSURLSession?
    var locationManager = CLLocationManager()
    
    var oldImage = ""
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location_now: CLLocation = locations.last!
        sprawdzaniePogody(String(format: "%f", location_now.coordinate.latitude), lon: String(format: "%f", location_now.coordinate.longitude))
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func sprawdzanieLokalizacji() {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
            self.locationManager.requestLocation()
        }
    }
    
    func sprawdzaniePogody(lat: String, lon: String) {
        var calaPrognoza: AnyObject?
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: sessionConfig)
        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?lat=50.061779&lon=19.939581&lang=pl&lang=pl&APPID=75e621cdfb3c7776e9b43e706b2ab5a3&units=metric")!
        //let url_ok = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?lat=" + lat + "&lon=" + lon + "&lang=pl&APPID=75e621cdfb3c7776e9b43e706b2ab5a3&units=metric")!
        session!.dataTaskWithURL(url)
            { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            do {
                calaPrognoza = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                
                    let weather = calaPrognoza!.valueForKeyPath("weather")
                    let opisPogodyValue = weather!.objectAtIndex(0).valueForKeyPath("description") as! String
                    let temperaturaPogoda = (calaPrognoza!.valueForKeyPath("main")?.valueForKeyPath("temp") as! Float)
                
                    self.opisPogody.setText(opisPogodyValue)
                    self.wstawianieObrazka(weather!.objectAtIndex(0).valueForKeyPath("icon") as! String)
                    self.temperaturaLabel.setText(String(format: "%.1f", temperaturaPogoda))
                
                let miasto = calaPrognoza!.valueForKeyPath("name") as! String
                
                self.miastoLabel.setText(miasto)
                
                //Data
                let data_now = calaPrognoza!.valueForKeyPath("dt") as! NSTimeInterval
                let data_teraz = NSDate(timeIntervalSince1970: data_now)
                let dataFormat = NSDateFormatter()
                dataFormat.dateFormat = "yyyy-MM-dd HH:mm"
                self.dataLabel.setText(dataFormat.stringFromDate(data_teraz))
                
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
            if oldImage != images {
                oldImage = images
                let dismissAction = WKAlertAction(title: "OK", style: WKAlertActionStyle.Cancel, handler: {})
                self.presentAlertControllerWithTitle("Brak obrazka", message: "Obrazek: \(images)", preferredStyle: WKAlertControllerStyle.Alert, actions: [dismissAction])
            }
        }
    }
    

    @IBAction func odsiewzPogode() {
        sprawdzanieLokalizacji()
    }
}

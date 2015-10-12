//
//  ViewController.swift
//  weather
//
//  Created by Sereni Rikheart on 10/7/15.
//  Copyright © 2015 Sereni Rikheart. All rights reserved.
//

import UIKit

class cityLocation {
    
    var cityName: String
    
    var cityCoord: String
    
    
    
    init(cityName: String, cityCoord: String){
        
        self.cityName = cityName
        
        self.cityCoord = cityCoord
        
    }
    
}

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
   
    @IBOutlet weak var pckrCity: UIPickerView!
    
    
    
    // кортеж с погодой на этот момент
    // precipitation содержит название иконки, если не будет картинок, можно переделать
    let cities: [cityLocation] = [
        cityLocation(cityName: "Moscow", cityCoord: "55.7522,37.6155"),
        cityLocation(cityName: "St. Petersburg", cityCoord: "59.9386,30.3141"),
        cityLocation(cityName: "Los Angeles", cityCoord: "37.8267,-122.423")
    ]
    
    var currentWeather: (temperature: String, precipitation: String, pressure: String) = ("--", "--", "--")
    
    // массив погоды по дням, устройство как у currentWeather
    var daily: [(temperature: String, precipitation: String, pressure: String)] = []
    
    var coordinates = "37.8267,-122.423"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // todo get coordinates from somewhere
        // todo check for missing values
        
        // @pluto: самый простой способ "выбрать" город – спросить координаты. сделаешь в интерфейсе возможность?
        
        getWeatherFor(coordinates)
        
        self.pckrCity.dataSource = self
        self.pckrCity.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getWeatherFor(coordinates: String) {
        // Call weather API with a given city id and pre-defined api key
        let APIKey = "1a263a07be7aa120ed40d088a0e2eaa6"
        
        // Construct url
        let URL = "https://api.forecast.io/forecast/\(APIKey)/\(coordinates)"
        
        let manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        manager.GET(URL,
            parameters: nil,
            success: {(operation: AFHTTPRequestOperation, responseObject: AnyObject) -> Void in
                
                // get response data in a dictionary
                let response = responseObject as! Dictionary<String, AnyObject>
                
//                print(response)
                
                // get data for current weather
                let currentData = response["currently"] as! Dictionary<String, AnyObject>
                
                // save current weather data to an internal variable
                self.currentWeather = (self.to_centigrade(String(currentData["apparentTemperature"]!)), String(currentData["icon"]!), self.mbar_to_mmhg(String(currentData["pressure"]!)))
                
                // get data for the next week
                let dailyData = response["daily"]
                // todo process daily data
            },
            failure: {(operation: AFHTTPRequestOperation, error: NSError) -> Void in
                print("\(error)")})

    }
    
    
    // American API; must convert measurement units
    func to_centigrade(value: String) -> String {
        // convert degrees in F to C
        return String(format: "%.0f", (Double(value)! - 32)*5/9)
    }
    
    func mbar_to_mmhg(value: String) -> String {
        // convert millibar to mmhg
        return String(format: "%.0f", Double(value)!*0.75)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return cities.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return cities[row].cityName
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        coordinates = cities[row].cityCoord
        
    }	

    @IBAction func btn1(sender: UIButton) {
        getWeatherFor(coordinates)
        lblTemperature.text = currentWeather.temperature
        
    }
   
}
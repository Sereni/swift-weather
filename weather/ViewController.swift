//
//  ViewController.swift
//  weather
//
//  Created by Sereni Rikheart on 10/7/15.
//  Copyright © 2015 Sereni Rikheart. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // connect table to code
    @IBOutlet weak var weatherTableView: UITableView!
    
    // holds table data
    var tableData = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // todo get city id from somewhere
        let coordinates = "37.8267,-122.423"
        getWeatherFor(coordinates)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getWeatherFor(coordinates: String) {
        // Call OpenWeather API with a given city id and pre-defined api key
        let APIKey = "1a263a07be7aa120ed40d088a0e2eaa6"
        
        // Construct url
        let URL = "https://api.forecast.io/forecast/\(APIKey)/\(coordinates)"
        
        let manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        manager.GET(URL,
            parameters: nil,
            success: {(operation: AFHTTPRequestOperation, responseObject: AnyObject) -> Void in
                print("\(responseObject)")
            },
            failure: {(operation: AFHTTPRequestOperation, error: NSError) -> Void in
                print("\(error)")})

    }

}
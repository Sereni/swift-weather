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
        let cityID = "524901"
        getWeatherFor(cityID)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getWeatherFor(cityID: String) {
        // Call OpenWeather API with a given city id and pre-defined api key
        let APIKey = "d15b15acb4da9baaaaacd99f93427014"
        
        // Construct url
        let URL = "http://api.openweathermap.org/data/2.5/forecast/city?id=\(cityID)&APPID=\(APIKey)"
        
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
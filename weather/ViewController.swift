//
//  ViewController.swift
//  weather
//
//  Created by Sereni Rikheart on 10/7/15.
//  Copyright © 2015 Sereni Rikheart. All rights reserved.
//

import UIKit

class CityLocation {
  
  var cityName: String
  var cityCoord: String
  
  init(cityName: String, cityCoord: String){
    self.cityName = cityName
    self.cityCoord = cityCoord
  }
}

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

  @IBOutlet weak var bgImage: UIImageView!
  @IBOutlet weak var lblTemperature: UILabel!
  @IBOutlet weak var lblPressure: UILabel!
  
  @IBOutlet weak var imgBig: UIImageView!
  
  @IBOutlet weak var pckrCity: UIPickerView!
  @IBOutlet weak var lblDate: UILabel!
  
  @IBOutlet weak var lbl1: UILabel!
  @IBOutlet weak var lbl2: UILabel!
  @IBOutlet weak var lbl3: UILabel!
  @IBOutlet weak var lbl4: UILabel!
  @IBOutlet weak var lbl5: UILabel!
  @IBOutlet weak var lbl6: UILabel!
  @IBOutlet weak var lbl7: UILabel!
  
  @IBOutlet weak var img1: UIImageView!
  @IBOutlet weak var img2: UIImageView!
  @IBOutlet weak var img3: UIImageView!
  @IBOutlet weak var img4: UIImageView!
  @IBOutlet weak var img5: UIImageView!
  @IBOutlet weak var img6: UIImageView!
  @IBOutlet weak var img7: UIImageView!
  
  // дефолтные параметры для юзера
  let defaultCity = NSUserDefaults.standardUserDefaults()
  
  // сегодняшняя дата и формат дат
  let today = NSDate()
  let dateFormatter = NSDateFormatter()
  
  let cities: [CityLocation] = [
    CityLocation(cityName: "Moscow", cityCoord: "55.7522,37.6155"),
    CityLocation(cityName: "St. Petersburg", cityCoord: "59.9386,30.3141"),
    CityLocation(cityName: "Los Angeles", cityCoord: "37.8267,-122.423")
  ]
  
  // иконка с сегодняшней погодой
  var weatherIcon: UIImage?
  
  // кортеж с погодой на этот момент
  var currentWeather: (temperature: String, precipitation: String, pressure: String) = ("--", "--", "--")
  
  // массив погоды по дням, устройство как у currentWeather
  var daily: [(temperature: String, precipitation: String, pressure: String)] = []
  
  var coordinates = "37.8267,-122.423"
  
  // массив лейблов с прогнозом
  var dailyLbls:[UILabel] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    getWeatherFor(coordinates) {(result: [(String, String, String)]) in
      
      // set first tuple as current weather
      self.currentWeather = result[0]
      
      // set all the other tuples as daily forecast
      self.daily = Array(result[1...7])
      
    }
    
    // добавление лейблов к массиву
    self.dailyLbls.append(self.lbl1)
    self.dailyLbls.append(self.lbl2)
    self.dailyLbls.append(self.lbl3)
    self.dailyLbls.append(self.lbl4)
    self.dailyLbls.append(self.lbl5)
    self.dailyLbls.append(self.lbl6)
    self.dailyLbls.append(self.lbl7)
    
    self.pckrCity.dataSource = self
    self.pckrCity.delegate = self
    
    // шрифты и фоны лейблов
    lblTemperature.backgroundColor = UIColor(white: 1, alpha: 0.6)
    lblPressure.backgroundColor = UIColor(white: 1, alpha: 0.6)
    lblDate.backgroundColor = UIColor(white: 1, alpha: 0.6)
    pckrCity.backgroundColor = UIColor(white: 1, alpha: 0.6)
    lblTemperature.font = UIFont.systemFontOfSize(60)
    lblTemperature.textColor = UIColor.darkGrayColor()
    lblPressure.font = UIFont.systemFontOfSize(20)
    lblPressure.textColor = UIColor.darkGrayColor()
    lblDate.font = UIFont.systemFontOfSize(20)
    lblDate.textColor = UIColor.darkGrayColor()
  }
  
  
  override func viewDidAppear(animated: Bool) {
    
    // по ключу получаем дефолтные значения (один юзер, поэтому ключ роли не играет)
    let defRow = defaultCity.integerForKey("itsme")
    
    // установка выбранного элемента списка
    pckrCity.selectRow(defRow, inComponent: 0, animated: true)
    
    coordinates = cities[defRow].cityCoord
    
    getWeatherFor(coordinates) {(result: [(String, String, String)]) in
      self.currentWeather = result[0]
      self.daily = Array(result[1...7])
      
      // вывод данных по дефолтному городу
      self.lblTemperature.text = self.currentWeather.temperature+"°С"
      self.lblPressure.text = self.currentWeather.pressure+" mm Hg"
      self.weatherIcon = UIImage(named: self.currentWeather.precipitation+".png")
      self.imgBig.image = self.weatherIcon
      self.view.addSubview(self.imgBig)
      
      // вывод даты в формате дата - месяц буквами - год
      self.dateFormatter.dateStyle = .LongStyle
      self.lblDate.text = self.dateFormatter.stringFromDate(self.today)
      
      self.bgImage.image = UIImage(named: self.currentWeather.precipitation+"bck.jpg")
      
      // заполнение прогноза
      for k in 0...6	{
        self.fillDaily(self.dailyLbls[k], num: k)
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func getWeatherFor(coordinates: String, completion: [(String, String, String)] -> Void) {
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
        
        // get data for current weather
        let currentData = response["currently"] as! Dictionary<String, AnyObject>
        
        var resultData: [(String, String, String)] = []
        
        // store current weather as first element
        resultData.insert((self.toCentigrade(String(currentData["apparentTemperature"]!)), String(currentData["icon"]!), self.mbarToMmhg(String(currentData["pressure"]!))), atIndex: 0)
        
        // get daily data
        let container = response["daily"] as! Dictionary<String, AnyObject>
        let dailyData = container["data"] as! Array<Dictionary<String, AnyObject>>
        for item in dailyData {
          resultData.append((self.toCentigrade(String(item["apparentTemperatureMax"]!)), String(item["icon"]!), self.mbarToMmhg(String(item["pressure"]!))))
        }
        
        completion(resultData)
      },
      failure: {(operation: AFHTTPRequestOperation, error: NSError) -> Void in
        print("\(error)")})
    
  }
  
  // American API; must convert measurement units
  func toCentigrade(value: String) -> String {
    // convert degrees in F to C
    return String(format: "%.0f", (Double(value)! - 32)*5/9)
  }
  
  func mbarToMmhg(value: String) -> String {
    // convert millibar to mmhg
    return String(format: "%.0f", Double(value)!*0.75)
  }
  
  // здесь заполняется прогноз
  func fillDaily(lbl: UILabel,  num: Int){
    var numberOfDays: Double!
    
    lbl.backgroundColor = UIColor(white: 1, alpha: 0.6)
    lbl.font = UIFont.systemFontOfSize(15)
    
    numberOfDays = Double(num+1)
    
    // получаем будущую дату добавлением временного интервала к сегодняшней
    let futureDate = self.today.dateByAddingTimeInterval(numberOfDays*24 * 60 * 60)
    
    // вывод в формате ден - месяц буквами
    dateFormatter.dateFormat = "dd MMMM"
    
    lbl.text = dateFormatter.stringFromDate(futureDate)+": "+self.daily[num].temperature+"°С, " + self.daily[num].pressure+" mm Hg"
    
  }
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return cities.count
  }
  
  // делаем список названий городов
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
    return cities[row].cityName
  }
  
  // происходящее при выборе города из списка
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    coordinates = cities[row].cityCoord
    
    getWeatherFor(coordinates) {(result: [(String, String, String)]) in
      self.currentWeather = result[0]
      self.daily = Array(result[1...7])
      
      // обновляются лейблы, значок погоды
      self.lblTemperature.text = self.currentWeather.temperature+"°С"
      self.lblPressure.text = self.currentWeather.pressure+" mm Hg"
      self.weatherIcon = UIImage(named: self.currentWeather.precipitation+".png")
      self.imgBig.image = self.weatherIcon
      self.view.addSubview(self.imgBig)
      
      // заполнение прогноза
      for i in 0...6	{
        self.fillDaily(self.dailyLbls[i], num: i)
      }
      
      // меняется фон
      self.bgImage.image = UIImage(named: self.currentWeather.precipitation+"bck.jpg")
      
      // Запоминаем выбранный последним город
      self.defaultCity.setInteger(row, forKey: "itsme")
    }
  }
}
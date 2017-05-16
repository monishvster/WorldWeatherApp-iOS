//
//  ViewController.swift
//  World_Weather
//
//  Created by Verma,Monish on 3/21/17.
//  Copyright © 2017 Verma,Monish. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var inputCity: UITextField!

    @IBOutlet weak var outputText: UITextView!

    @IBAction func getWeather(_ sender: Any) {
        
        let appID:String = "7582021b2a13ede2c424f6d5e2d78b07"
        let city:String = inputCity.text!
        var description:[String] = []
        var currentTemp:Double = 0
        var maxTemp:Double = 0
        var minTemp:Double = 0
        var humidity:Double = 0
        var windSpeed:Double = 0
        let url:String = "http://api.openweathermap.org/data/2.5/weather?q=\(city.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))&APPID=\(appID)"
        let urlRequest = URL(string: url)
        let task = URLSession.shared.dataTask(with: urlRequest!,
                                   completionHandler: {
                                    (data,response,error) in
                                    if error != nil {
                                        print(error.debugDescription)
                                    }
                                    else {
                                        do {
                                            let myResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                                            let descriptionArray = myResponse["weather"]!
                                            let tempArray = myResponse["main"] as! [String:Any]!
                                            let windArray = myResponse["wind"] as! [String:Any]!
                                            
                                            windSpeed = windArray?["speed"] as! Double
                                            currentTemp = tempArray?["temp"] as! Double
                                            maxTemp = tempArray?["temp_max"] as! Double
                                            minTemp = tempArray?["temp_min"] as! Double
                                            humidity = tempArray?["humidity"] as! Double
                                            
                                            //Fetch description from weather array
                                            for index in 0...descriptionArray.count-1 {
                                                let aObject = descriptionArray[index] as! [String:AnyObject]
                                                description.append(aObject["description"] as! String)
                                            }
                                            
                                            
                                            
                                            //Displaying output
                                            DispatchQueue.main.async {
                                                   self.outputText.text = "\(description[0].uppercaseFirst)\nCurrent temp: \(Int(currentTemp - 273.15)) C\nMax temp: \(Int(maxTemp - 273.15)) C\nMin temp: \(Int(minTemp - 273.15)) C\nHumidity: \(humidity)%\nWindspeed: \(windSpeed)"
                                            }

                                            
                                        }
                                        catch let error as NSError {
                                            print(error)
                                        }
                                    }
        })
        task.resume()
        
    }
}

//capitalize first character
extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
}



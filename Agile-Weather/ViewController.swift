//
//  ViewController.swift
//  Agile-Weather
//
//  Created by Pranav Durai  on 14/04/20.
//  Copyright © 2020 Pranav Durai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let url = URL(string: "api.openweathermap.org/data/2.5/weather?zip=560043,IND&appid=d97a582c2b94c432db1760715c3c27ad") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else { return }
                    guard let weatherDetails = json["weather"] as? [[String : Any]], let weatherMain = json["main"] as? [String : Any] else { return }
                    let temp = Int(weatherMain["temp"] as? Double ?? 0)
                    //let description = (weatherDetails.first?["description"] as? String)?.capitalizingFirstLetter()
                    let description = (weatherDetails.first?["description"] as? String)?.capitalizingFirstLetter()
                  
                    DispatchQueue.main.async
                        {
                            self.setWeather(weather: weatherDetails.first?["main"] as? String, description: description, temp: temp)
                        }
                   }    catch   {
                                    print("Error retriving weather data!")
                                }
                
                    }
                }
        
                task.resume()
            }


    func setWeather(weather: String?, description: String?, temp: Int)
    {
        weatherDescriptionLabel.text = description ?? "..."
        tempLabel.text = "\(temp)°"
        switch weather
        {
            case "Sunny":
                weatherImageView.image = UIImage (named: "Sunny")
                background.backgroundColor = UIColor(_colorLiteralRed: 0.97, green: 0.78, blue: 0.35, alpha: 1.0)
                    // red:0.97, green:0.78, blue:0.35, apha:1.0
                    // _colorLiteralRed: 0.97, green: 0.78, blue: 0.35, alpha: 1.0
            default:
                weatherImageView.image = UIImage (named: "Cloudy")
                background.backgroundColor = UIColor(_colorLiteralRed: 0.42, green: 0.55, blue: 0.71, alpha: 1.0)

        }
    }
}

extension String
{
    func capitalizingFirstLetter() -> String
    {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

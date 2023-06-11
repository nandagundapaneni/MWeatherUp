//
//  ViewController.swift
//  MWeatherUp
//
//  Created by Nanda Gundapaneni on 11/06/23.
//

import UIKit
import Kingfisher

let cityNameCellIdentiifier = "cityNameCellIdentiifier"

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temparatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    
    lazy var geoCodeService = GeoCodeService()
    lazy var openWeatherService = OpenWeatherService()
    
    var geoCodeWeather: OpenWeather? {
        didSet{
            self.updateWeatherUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let lastSearched = UserDefaults.lastSearchedCity {
            geoCodeService.getGeoCodeData(searchString: lastSearched) { success, results, error in
                if let results = results, let first = results.first {
                    UserDefaults.lastSearchedCity = first.name
                    self.openWeatherService.getWeather(coord: Coord(lon: first.lon, lat: first.lat)) { success, weather, error in
                        self.geoCodeWeather = weather
                        print(weather?.name ?? "NO data")
                    }
                }
            }
        }
    }
}

extension ViewController {
    func updateWeatherUI() {
        if let weatherData = geoCodeWeather {
            DispatchQueue.main.async {
                self.temparatureLabel.text = weatherData.main.temp.temperatureString()
                self.nameLabel.text = weatherData.name
                self.conditionLabel.text = "\(weatherData.weather.first?.description ?? "--") \tH:\(weatherData.main.tempMax.temperatureString()) L:\(weatherData.main.tempMin.temperatureString())"
                let icon = weatherData.weather.first?.icon ?? ""
                self.conditionImageView.kf.setImage(
                    with: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png"),
                    placeholder: nil
                )
            }
        }
       
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        geoCodeService.getGeoCodeData(searchString: searchBar.text ?? "New York") { success, results, error in
            if let results = results, let first = results.first {
                UserDefaults.lastSearchedCity = first.name
                self.openWeatherService.getWeather(coord: Coord(lon: first.lon, lat: first.lat)) { success, weather, error in
                    self.geoCodeWeather = weather
                    print(weather?.name ?? "NO data")
                }
            }
        }
    }
}

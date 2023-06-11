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
    
    // MARK: - IBoutlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temparatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    
    @IBOutlet weak var locationTempratureLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationConditionImageView: UIImageView!
    @IBOutlet weak var locationForecastLabel: UILabel!
    @IBOutlet weak var locationConditionLabel: UILabel!
    
    // MARK: - Service
    lazy var geoCodeService = GeoCodeService()
    lazy var openWeatherService = OpenWeatherService()
    lazy var locationService = LocationService()
    
    // MARK: - Setters
    var geoCodeWeather: OpenWeather? {
        didSet{
            self.updateWeatherUI()
        }
    }
    
    var locationWeather: OpenWeather? {
        didSet{
            self.updateLocationWeatherUI()
        }
    }
    
    // MARK: - Lifecycle ovverides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // This could have handled better if all this handled by a ViewModel.
        locationService.start { location in
            self.openWeatherService.getWeather(coord: Coord(lon: location.coordinate.longitude, lat: location.coordinate.latitude)) { success, weather, error in
                self.locationWeather = weather
                print(weather?.name ?? "NO data")
            }
        }
        
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

//MARK: - UI updates
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
    
    func updateLocationWeatherUI() {
        if let weatherData = locationWeather {
            DispatchQueue.main.async {
                self.locationTempratureLabel.text = weatherData.main.temp.temperatureString()
                self.locationNameLabel.text = weatherData.name
                self.locationConditionLabel.text = "\(weatherData.weather.first?.description ?? "--")"
                self.locationForecastLabel.text = "H:\(weatherData.main.tempMax.temperatureString()) \tL:\(weatherData.main.tempMin.temperatureString())"
                let icon = weatherData.weather.first?.icon ?? ""
                self.locationConditionImageView.kf.setImage(
                    with: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png"),
                    placeholder: nil
                )
            }
        }
    }
}

// MARK: - SearchBar Delegate

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

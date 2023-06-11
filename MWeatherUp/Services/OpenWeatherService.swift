//
//  OpenWeatherService.swift
//  MWeatherUp
//
//  Created by Nanda Gundapaneni on 11/06/23.
//

import Foundation

let appidKey = "&appid=5ddb648a8cf4f85c40ab051ce73afa08"
let openWeatherBaseURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
let iconBaseURL = "https://openweathermap.org/img/wn/"

protocol OpenWeatherServiceProtocol {
    func getWeather(coord: Coord, completion: @escaping (_ success: Bool, _ results: OpenWeather?, _ error: String?) -> ())
}

class OpenWeatherService : OpenWeatherServiceProtocol {
    func getWeather(coord: Coord, completion: @escaping (Bool, OpenWeather?, String?) -> ()) {
        
        let urlString = openWeatherBaseURL+"&lat=\(coord.lat)&lon=\(coord.lon)\(appidKey)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error{
                    completion(false,nil,error.localizedDescription)
                }
                guard let data = data else {
                    completion(false,nil,"data error")
                    return
                }
                
                do {
                    let results = try JSONDecoder().decode(OpenWeather.self, from: data)
                    completion(true,results,nil)
                }catch {
                    completion(false,nil,"Error Data encoding error")
                }
            }.resume()
        }
    }
    
    

}

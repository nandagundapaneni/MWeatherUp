//
//  GeoCodeService.swift
//  MWeatherUp
//
//  Created by Nanda Gundapaneni on 11/06/23.
//

import Foundation

let geoCodeBaseURL = "https://api.openweathermap.org/geo/1.0/direct?limit=5&appid=5ddb648a8cf4f85c40ab051ce73afa08"

protocol GeoCodeServiceProtocol {
    func getGeoCodeData(searchString: String, completion: @escaping (_ success: Bool, _ results: GeoCode?, _ error: String?) -> ())
}

class GeoCodeService : GeoCodeServiceProtocol {
    
    func getGeoCodeData(searchString: String, completion: @escaping (Bool, GeoCode?, String?) -> ()) {
        
        let urlEncodeSearchText = searchString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? searchString
        let urlString = geoCodeBaseURL+"&q="+urlEncodeSearchText
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
                    let results = try JSONDecoder().decode(GeoCode.self, from: data)
                    completion(true,results,nil)
                }catch {
                    completion(false,nil,"Error Data encoding error")
                }
            }.resume()
        }
    }
    
    

}

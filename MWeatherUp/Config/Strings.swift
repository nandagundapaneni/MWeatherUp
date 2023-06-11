//
//  Strings.swift
//  MWeatherUp
//
//  Created by Nanda Gundapaneni on 11/06/23.
//

import Foundation

struct Strings {
    enum Errors {
        static let error = "Error"
        static let tryAgain = "Please try again."
        static let networkError = "Unable to load data"
    }
    
    enum Home {
        static let weather = "Weather"
        static let currentLocation = "Current Location"
        static let recents = "Recently Searched"
        static let searchPlaceholder = "Search by City"
        static let searchResults = "Result"
        static let feelsLike = "Feels Like"
        static let wind = "Wind"
        static let pressure = "Pressure"
    }
    
    enum Button {
        static let refresh = "Refresh"
    }
}

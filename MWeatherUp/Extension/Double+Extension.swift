//
//  Double+Extension.swift
//  MWeatherUp
//
//  Created by Nanda Gundapaneni on 11/06/23.
//

import Foundation

extension Double {
    func temperatureString() -> String {
        let degreeSymbol = "\u{00B0}"
        let roundedTemperature = Int(self.rounded())
        return "\(roundedTemperature)\(degreeSymbol)C"
    }
}

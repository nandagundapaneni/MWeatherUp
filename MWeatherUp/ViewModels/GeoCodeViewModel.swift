//
//  GeoCodeViewModel.swift
//  MWeatherUp
//
//  Created by Nanda Gundapaneni on 11/06/23.
//

import Foundation

protocol GeoCodeVMProtocol {
    
}

class GeoCodeViewModel: NSObject {
    private var geoCodeService: GeoCodeServiceProtocol
    private(set) var cities: GeoCode? {
        didSet {
            
        }
    }

    init(geoCodeService: GeoCodeServiceProtocol) {
        self.geoCodeService = geoCodeService
    }
}

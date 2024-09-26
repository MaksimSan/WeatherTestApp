//
//  SearchResultResponse.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import Foundation

struct SearchResultResponse: Decodable {
    
    /// Наименование города
    let name: String
    /// Месторасположение города
    let place: String?
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case place = "state"
    }
}

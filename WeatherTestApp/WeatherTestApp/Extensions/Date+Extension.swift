//
//  Date+Extension.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import Foundation

extension Date {
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}

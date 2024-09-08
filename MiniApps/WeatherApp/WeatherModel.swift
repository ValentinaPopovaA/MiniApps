//
//  WeatherModel.swift
//  MiniApps
//
//  Created by Валентина Попова on 08.09.2024.
//

import Foundation

struct WeatherData: Codable {
    let temperature: Double
    let feelsLike: Double
    let condition: String
    let cityName: String
    let icon: String
    let timestamp: Date
}

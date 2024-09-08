//
//  WeatherAPI.swift
//  MiniApps
//
//  Created by Валентина Попова on 08.09.2024.
//

import Foundation
import CoreLocation

final class WeatherAPI {

    private let apiKey = "API_KEY"
    
    func fetchWeather(for location: CLLocation, completion: @escaping (WeatherData?) -> Void) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric&lang=ru"
        
        guard let url = URL(string: urlString) else {
            print("Неверный URL: \(urlString)")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка получения данных о погоде: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("Нет данных")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let weatherData = self.parseWeatherData(json: json)
                    completion(weatherData)
                }
            } catch {
                print("Ошибка парсинга JSON: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    private func parseWeatherData(json: [String: Any]) -> WeatherData? {
        guard let main = json["main"] as? [String: Any],
              let temperature = main["temp"] as? Double,
              let feelsLike = main["feels_like"] as? Double,
              let weatherArray = json["weather"] as? [[String: Any]],
              let weather = weatherArray.first,
              let condition = weather["description"] as? String,
              let icon = weather["icon"] as? String,
              let cityName = json["name"] as? String else {
            print("Ошибка парсинга данных о погоде")
            return nil
        }
        
        return WeatherData(
            temperature: temperature,
            feelsLike: feelsLike,
            condition: condition,
            cityName: cityName,
            icon: icon,
            timestamp: Date()
        )
    }
}

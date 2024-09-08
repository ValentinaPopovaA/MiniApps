//
//  WeatherViewController.swift
//  MiniApps
//
//  Created by Валентина Попова on 04.09.2024.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        return manager
    }()
    
    private let weatherAPI = WeatherAPI()
    private let weatherView = WeatherView()
    
    override func loadView() {
        self.view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cachedData = loadCachedWeatherData(), !isCacheExpired(for: cachedData) {
            updateUI(with: cachedData)
        } else {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    private func updateUI(with weatherData: WeatherData) {
        weatherView.temperatureLabel.text = "\(Int(weatherData.temperature))°C"
        weatherView.feelsLikeLabel.text = "Ощущается как \(Int(weatherData.feelsLike))°C"
        weatherView.conditionLabel.text = weatherData.condition.capitalized
        weatherView.cityLabel.text = weatherData.cityName
        loadWeatherIcon(from: URL(string: "https://openweathermap.org/img/wn/\(weatherData.icon)@2x.png")!)
    }
    
    private func loadWeatherIcon(from url: URL?) {
        guard let url = url else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Ошибка загрузки иконки погоды: \(error)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Ошибка декодирования иконки погоды")
                return
            }
            
            DispatchQueue.main.async {
                self?.weatherView.weatherIcon.image = image
            }
        }
        
        task.resume()
    }
    
    private func loadCachedWeatherData() -> WeatherData? {
        if let savedData = UserDefaults.standard.data(forKey: "cachedWeatherData"),
           let decodedData = try? JSONDecoder().decode(WeatherData.self, from: savedData) {
            return decodedData
        }
        return nil
    }
    
    private func isCacheExpired(for weatherData: WeatherData) -> Bool {
        let oneHourAgo = Date().addingTimeInterval(-3600)
        return weatherData.timestamp < oneHourAgo
    }
    
    private func cacheWeatherData(_ weatherData: WeatherData) {
        if let encoded = try? JSONEncoder().encode(weatherData) {
            UserDefaults.standard.set(encoded, forKey: "cachedWeatherData")
        }
    }
    
    // CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            weatherAPI.fetchWeather(for: location) { [weak self] weatherData in
                guard let self = self, let weatherData = weatherData else { return }
                self.cacheWeatherData(weatherData)
                DispatchQueue.main.async {
                    self.updateUI(with: weatherData)
                }
            }
        }
    }
}

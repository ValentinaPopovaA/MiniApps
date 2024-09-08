//
//  WeatherView.swift
//  MiniApps
//
//  Created by Валентина Попова on 08.09.2024.
//

import UIKit

final class WeatherView: UIView {
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 80, weight: .thin)
        label.textAlignment = .center
        return label
    }()
    
    let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textAlignment = .center
        return label
    }()
    
    let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .light)
        label.textAlignment = .center
        return label
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    let weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let greetingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textAlignment = .center
        label.text = WeatherView.getGreeting()
        return label
    }()
    
    let dayOfWeekLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 35, weight: .light)
        label.textAlignment = .center
        label.text = WeatherView.getDayOfWeek()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        
        addSubview(greetingLabel)
        addSubview(dayOfWeekLabel)
        addSubview(temperatureLabel)
        addSubview(feelsLikeLabel)
        addSubview(conditionLabel)
        addSubview(cityLabel)
        addSubview(weatherIcon)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        dayOfWeekLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        feelsLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            cityLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            weatherIcon.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20),
            weatherIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherIcon.heightAnchor.constraint(equalToConstant: 200),
            weatherIcon.widthAnchor.constraint(equalToConstant: 200),
            
            temperatureLabel.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 20),
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            feelsLikeLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10),
            feelsLikeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            conditionLabel.topAnchor.constraint(equalTo: feelsLikeLabel.bottomAnchor, constant: 10),
            conditionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            greetingLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -150),
            greetingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            dayOfWeekLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 10),
            dayOfWeekLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private static func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            return "Доброе утро, сегодня"
        case 12..<18:
            return "Добрый день, сегодня"
        case 18..<22:
            return "Добрый вечер, сегодня"
        default:
            return "Доброй ночи, сегодня"
        }
    }
    
    private static func getDayOfWeek() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date).capitalized
    }
}

//
//  LocationView.swift
//  MiniApps
//
//  Created by Валентина Попова on 08.09.2024.
//

import UIKit

final class LocationView: UIView {
    
    private let hereLabel: UILabel = {
        let label = UILabel()
        label.text = "Вы здесь"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemCyan
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
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
        
        addSubview(hereLabel)
        addSubview(cityLabel)
        addSubview(dateTimeLabel)
        
        NSLayoutConstraint.activate([
            hereLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            hereLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            cityLabel.topAnchor.constraint(equalTo: hereLabel.bottomAnchor, constant: 70),
            cityLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            dateTimeLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 70),
            dateTimeLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

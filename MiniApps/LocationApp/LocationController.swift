//
//  TimeViewController.swift
//  MiniApps
//
//  Created by Валентина Попова on 05.09.2024.
//

import UIKit

final class LocationController: UIViewController {
    
    private let locationModel = LocationModel()
    private let locationView = LocationView()
    
    override func loadView() {
        view = locationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocation()
    }

    private func updateLocation() {
        locationModel.requestLocationUpdate { [weak self] locationData in
            self?.locationView.cityLabel.text = locationData.city
            self?.locationView.dateTimeLabel.text = locationData.date
        }
    }
}

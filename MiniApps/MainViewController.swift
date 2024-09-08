//
//  ViewController.swift
//  MiniApps
//
//  Created by Валентина Попова on 04.09.2024.
//

import UIKit

final class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private var displayMode: DisplayMode = .small
    
    enum DisplayMode {
        case small
        case large
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MiniAppTableViewCell.self, forCellReuseIdentifier: "miniAppCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let switchDisplayModeButton = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet"),
            style: .plain,
            target: self,
            action: #selector(switchDisplayMode)
        )
        switchDisplayModeButton.tintColor = .black
        navigationItem.rightBarButtonItem = switchDisplayModeButton
    }
    
    @objc private func switchDisplayMode() {
        displayMode = (displayMode == .small) ? .large : .small
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if displayMode == .large {
            let cell = tableView.dequeueReusableCell(withIdentifier: "miniAppCell", for: indexPath) as! MiniAppTableViewCell
            
            let miniAppView: UIView
            
            if indexPath.row % 3 == 0 {
                let weatherViewController = WeatherViewController()
                addChild(weatherViewController)
                miniAppView = weatherViewController.view
                weatherViewController.didMove(toParent: self)
            } else if indexPath.row % 3 == 1 {
                let ticTacToeViewController = TicTacToeViewController()
                addChild(ticTacToeViewController)
                miniAppView = ticTacToeViewController.view
                ticTacToeViewController.didMove(toParent: self)
            } else {
                let locationViewController = LocationController()
                addChild(locationViewController)
                miniAppView = locationViewController.view
                locationViewController.didMove(toParent: self)
            }
            
            cell.configure(with: miniAppView)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
            cell.textLabel?.numberOfLines = 2
            
            let iconView = UIImageView()
            iconView.contentMode = .scaleAspectFit
            iconView.tintColor = .systemCyan
            
            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            
            let subtitleLabel = UILabel()
            subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
            subtitleLabel.numberOfLines = 0
            subtitleLabel.textColor = .gray
            
            if indexPath.row % 3 == 0 {
                iconView.image = UIImage(systemName: "cloud.sun")
                titleLabel.text = "Погода"
                subtitleLabel.text = "Погода для текущего местоположения"
            } else if indexPath.row % 3 == 1 {
                iconView.image = UIImage(systemName: "square.grid.3x3.topleft.filled")
                titleLabel.text = "Крестики-нолики"
                subtitleLabel.text = "Игра в крестики-нолики с компьютером"
            } else {
                iconView.image = UIImage(systemName: "location")
                titleLabel.text = "Местоположение"
                subtitleLabel.text = "Покажет текущее местоположение"
            }
            
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            
            cell.contentView.addSubview(iconView)
            cell.contentView.addSubview(titleLabel)
            cell.contentView.addSubview(subtitleLabel)
            
            iconView.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                iconView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                iconView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                iconView.heightAnchor.constraint(equalTo: cell.contentView.heightAnchor, multiplier: 0.6),
                iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
                
                titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
                titleLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                titleLabel.topAnchor.constraint(equalTo: iconView.topAnchor),
                
                subtitleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
                subtitleLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
            ])
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isPortrait = UIDevice.current.orientation.isPortrait
        switch displayMode {
        case .small:
            return isPortrait ? view.frame.height / 8 : view.frame.height / 5
        case .large:
            return isPortrait ? view.frame.height / 2 : view.frame.height / 3
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if displayMode == .small {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let selectedApp = indexPath.row % 3
            let detailViewController: UIViewController
            
            switch selectedApp {
            case 0:
                detailViewController = WeatherViewController()
            case 1:
                detailViewController = TicTacToeViewController()
            case 2:
                detailViewController = LocationController()
            default:
                return
            }
            
            let backItem = UIBarButtonItem()
            backItem.title = "Назад"
            backItem.tintColor = .black
            navigationItem.backBarButtonItem = backItem
            
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.tableView.reloadData()
        }, completion: nil)
    }
}

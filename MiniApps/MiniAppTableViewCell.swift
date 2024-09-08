//
//  MiniAppTableViewCell.swift
//  MiniApps
//
//  Created by Валентина Попова on 07.09.2024.
//

import UIKit

class MiniAppTableViewCell: UITableViewCell {

    private let miniAppContainerView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContainerView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupContainerView()
    }

    private func setupContainerView() {
        contentView.addSubview(miniAppContainerView)
        miniAppContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            miniAppContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            miniAppContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            miniAppContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            miniAppContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        miniAppContainerView.subviews.forEach { $0.removeFromSuperview() }
        miniAppContainerView.frame.size = CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }

    func configure(with view: UIView) {
        miniAppContainerView.subviews.forEach { $0.removeFromSuperview() }

        miniAppContainerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: miniAppContainerView.topAnchor),
            view.leadingAnchor.constraint(equalTo: miniAppContainerView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: miniAppContainerView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: miniAppContainerView.bottomAnchor)
        ])
    }
}

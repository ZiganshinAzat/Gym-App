//
//  IconsCollectionViewCell.swift
//  GymApp
//
//  Created by Азат Зиганшин on 27.03.2024.
//

import UIKit

class IconsCollectionViewCell: UICollectionViewCell {

    lazy var iconImageView: UIImageView = {
        var imageView = RoundImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill

        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(iconTapped))
        imageView.addGestureRecognizer(tapGesture)

        return imageView
    }()

    var imageViewTapped: ((String) -> Void)?
    var iconName: String?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}

extension IconsCollectionViewCell {

    func setupLayout() {
        backgroundColor = UIColor(red: 8/255, green: 10/255, blue: 23/255, alpha: 1.0)

        contentView.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

    func configureCell(with iconName: String) {
        iconImageView.image = UIImage(named: iconName)
        self.iconName = iconName
    }

    @objc func iconTapped() {
        if let imageViewTapped {
            imageViewTapped(iconName ?? "")
        } else {
            print("No action for imageView")
        }
    }
}

//
//  ProfileView.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.05.2024.
//

import UIKit

class ProfileView: UIView {

    lazy var profileLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Профиль"
        return label
    }()

    lazy var logoutButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Выйти", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)

        let action = UIAction { [weak self] _ in
            guard let self = self else { return }

            if let logoutButtonAction = self.logoutButtonAction {
                logoutButtonAction()
            } else {
                print("No action for login button")
            }
        }
        button.addAction(action, for: .touchUpInside)

        return button
    }()

    lazy var avatarImageView: UIImageView = {
        var imageView = RoundImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray

        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarImageViewTapped))
        imageView.addGestureRecognizer(tapGesture)

        return imageView
    }()

    lazy var helloLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
//        label.text = "Привет!"
        return label
    }()

    var logoutButtonAction: (() -> Void)?
    var avatarImageViewTapAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileView {
    @objc func avatarImageViewTapped() {
        if let avatarImageViewTapAction {
            avatarImageViewTapAction()
        } else {
            print("No action for imageView")
        }
    }

    func setupLayout() {
        backgroundColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)

        addSubview(profileLabel)
        addSubview(logoutButton)
        addSubview(avatarImageView)
        addSubview(helloLabel)

        NSLayoutConstraint.activate([
            profileLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            profileLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),

            logoutButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 30),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor),

            helloLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 15),
            helloLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
        ])
    }
}

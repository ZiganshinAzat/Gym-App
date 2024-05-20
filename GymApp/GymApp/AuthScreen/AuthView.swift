//
//  AuthView.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.05.2024.
//

import UIKit

class AuthView: UIView {

    lazy var welcomeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.textColor = UIColor(red: 0x93/255, green: 0x70/255, blue: 0xDB/255, alpha: 1.0)
        label.textAlignment = .center
        label.text = "Welcome to GymMaster"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping

        return label
    }()

    lazy var loginButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 0x93/255, green: 0x70/255, blue: 0xDB/255, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 20
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0), for: .normal)

        let action = UIAction { [weak self] _ in

            if let logInButtonAction = self?.logInButtonAction {
                logInButtonAction()
            } else {
                print("Не добавлено событие на кнопку")
            }
        }
        button.addAction(action, for: .touchUpInside)

        return button
    }()

    lazy var signupButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0xA9/255, green: 0xA9/255, blue: 0xA9/255, alpha: 1.0).cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 20
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor(red: 0xA9/255, green: 0xA9/255, blue: 0xA9/255, alpha: 1.0), for: .normal)

        let action = UIAction { [weak self] _ in

            if let signUpButtonAction = self?.signUpButtonAction {
                signUpButtonAction()
            } else {
                print("Не добавлено событие на кнопку")
            }
        }
        button.addAction(action, for: .touchUpInside)

        return button
    }()

    var logInButtonAction: (() -> Void)?
    var signUpButtonAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AuthView {
    func setupLayout() {
        backgroundColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)

        addSubview(welcomeLabel)
        addSubview(loginButton)
        addSubview(signupButton)

        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 300),
            welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            loginButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            loginButton.heightAnchor.constraint(equalToConstant: 46),

            signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            signupButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            signupButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            signupButton.heightAnchor.constraint(equalTo: loginButton.heightAnchor)
        ])
    }
}

//
//  LoginView.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.05.2024.
//

import UIKit

class LoginView: UIView {

    var viewModel: LoginViewModel! {
        didSet {
            setupViewModelBindings()
        }
    }

    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.textColor = UIColor(red: 0x93/255, green: 0x70/255, blue: 0xDB/255, alpha: 1.0)
        label.textAlignment = .center
        label.text = "GymMaster"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping

        return label
    }()

    lazy var loginLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
        label.textColor = UIColor(red: 0xA9/255, green: 0xA9/255, blue: 0xA9/255, alpha: 1.0)
        label.textAlignment = .center
        label.text = "Login"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping

        return label
    }()

    lazy var emailTextField: UITextField = {
        getTextField(with: "Email")
    }()

    lazy var passwordTextField: UITextField = {
        let textField = getTextField(with: "Пароль")
        textField.isSecureTextEntry = true
        return textField
    }()

    lazy var loginButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 0x93/255, green: 0x70/255, blue: 0xDB/255, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 20
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0), for: .normal)

        let action = UIAction { [weak self] _ in
            guard let self = self else { return }

            if let loginButtonAction = self.loginButtonAction {
                guard let email = self.emailTextField.text,
                      let password = self.passwordTextField.text else { return }
                loginButtonAction(email, password)
            } else {
                print("No action for login button")
            }
        }
        button.addAction(action, for: .touchUpInside)

        return button
    }()

    var loginButtonAction: ((_ email: String?, _ password: String?) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginView {

    private func setupViewModelBindings() {
        viewModel.onValidationError = { [weak self] error in
            switch error {
            case .email:
                self?.emailTextField.applyErrorStyle()
            case .password:
                self?.passwordTextField.applyErrorStyle()
            case .name:
                return
            }
        }

        viewModel.onValidationSuccess = { [weak self] field in
            switch field {
            case .email:
                self?.emailTextField.applyNormalStyle()
            case .password:
                self?.passwordTextField.applyNormalStyle()
            case .name:
                return
            }
        }
    }

    func setupLayout() {
        backgroundColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)

        addSubview(titleLabel)
        addSubview(loginLabel)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 200),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            loginLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            loginLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            emailTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            loginButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }

    private func getTextField(with placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(red: 20/255, green: 24/255, blue: 41/255, alpha: 1.0)
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 40/255, green: 42/255, blue: 60/255, alpha: 1.0).cgColor
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.textColor = .white
        let textFieldTextColor = UIColor(red: 0xA9/255, green: 0xA9/255, blue: 0xA9/255, alpha: 1.0)
        let attributes = [NSAttributedString.Key.foregroundColor: textFieldTextColor]
        let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder

        return textField
    }
}

//
//  RegistrationView.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.05.2024.
//

import UIKit

class RegistrationView: UIView {

    var viewModel: RegistrationViewModel! {
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

    lazy var registrationLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
        label.textColor = UIColor(red: 0xA9/255, green: 0xA9/255, blue: 0xA9/255, alpha: 1.0)
        label.textAlignment = .center
        label.text = "Registration"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping

        return label
    }()

    lazy var nameTextField: UITextField = {
        getTextField(with: "Имя")
    }()

    lazy var emailTextField: UITextField = {
        getTextField(with: "Email")
    }()

    lazy var passwordTextField: UITextField = {
        getTextField(with: "Пароль")
    }()

    lazy var registerButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 0x93/255, green: 0x70/255, blue: 0xDB/255, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 20
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0), for: .normal)

        let action = UIAction { [weak self] _ in
            self?.registerButtonTapped()
        }
        button.addAction(action, for: .touchUpInside)

        return button
    }()

    var registerButtonAction: ((_ name: String?, _ email: String?, _ password: String?) -> Void)?
    var showEmailValidationAlert: (() -> Void)?
    var showPasswordValidationAlert: (() -> Void)?
    var showNameValidationAlert: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RegistrationView {

    private func setupViewModelBindings() {
        viewModel.onValidationError = { [weak self] error in
            switch error {
            case .name:
                self?.nameTextField.applyErrorStyle()
                self?.showNameValidationAlert?()
            case .email:
                self?.emailTextField.applyErrorStyle()
                self?.showEmailValidationAlert?()
            case .password:
                self?.passwordTextField.applyErrorStyle()
                self?.showPasswordValidationAlert?()
            }
        }

        viewModel.onValidationSuccess = { [weak self] field in
            switch field {
            case .name:
                self?.nameTextField.applyNormalStyle()
            case .email:
                self?.emailTextField.applyNormalStyle()
            case .password:
                self?.passwordTextField.applyNormalStyle()
            }
        }
    }

    private func registerButtonTapped() {
        guard viewModel.validate(
            name: nameTextField.text,
            email: emailTextField.text,
            password: passwordTextField.text
        ) else { return }

        if let registerButtonAction {
            registerButtonAction(nameTextField.text, emailTextField.text, passwordTextField.text)
        } else {
            print("No action")
        }
    }

    func setupLayout() {
        backgroundColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)

        addSubview(titleLabel)
        addSubview(registrationLabel)
        addSubview(nameTextField)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(registerButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 200),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            registrationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            registrationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            nameTextField.topAnchor.constraint(equalTo: registrationLabel.bottomAnchor, constant: 40),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),

            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),

            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            registerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            registerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            registerButton.heightAnchor.constraint(equalToConstant: 46)
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
        let attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: attributes
        )
        textField.attributedPlaceholder = attributedPlaceholder

        return textField
    }
}

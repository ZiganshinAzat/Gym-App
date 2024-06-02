//
//  RegistrationViewController.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.05.2024.
//

import UIKit

class RegistrationViewController: UIViewController {

    private let registrationViewModel: RegistrationViewModel
    private let registrationView = RegistrationView()

    init(registrationViewModel: RegistrationViewModel) {
        self.registrationViewModel = registrationViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = registrationView
        registrationView.viewModel = registrationViewModel
        registrationView.registerButtonAction = registerUser(_:_:_:)
        registrationView.showEmailValidationAlert = showEmailValidationAlert
        registrationView.showPasswordValidationAlert = showPasswordValidationAlert
        registrationView.showNameValidationAlert = showNameValidationAlert
        registrationViewModel.onRegistrationFailure = onRegistrationFailure
        registrationViewModel.onRegistrationSuccess = onRegistrationSuccess
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor(red: 0x93/255, green: 0x70/255, blue: 0xDB/255, alpha: 1.0)
    }
}

extension RegistrationViewController {

    func registerUser(_ name: String?, _ email: String?, _ password: String?) {
        registrationViewModel.registerUser(name, email, password)
    }

    func onRegistrationSuccess() {
        DispatchQueue.main.async {
            let profileViewModel = ProfileViewModel()
            let profileViewController = ProfileViewController(profileViewModel: profileViewModel)

            if let tabBarController = self.tabBarController {
                if let navController = tabBarController.viewControllers?[3] as? UINavigationController {
                    navController.setViewControllers([profileViewController], animated: true)
                    tabBarController.selectedIndex = 3
                }
            }
        }
    }

    func onRegistrationFailure(error: Error) {
        print(error)
        showEmailAlreadyExistsAlert()
    }

    func showEmailAlreadyExistsAlert() {
        let alert = UIAlertController(title: "Ошибка регистрации", message: "Пользователь с такой почтой уже существует", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in

        }))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    func showEmailValidationAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Некорректный адрес электронной почты", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in

        }))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    func showPasswordValidationAlert() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Пароль должен содержать как минимум одну заглавную букву, одну цифру, один спецсимвол и быть длиной не менее 8 символов.",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in

        }))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }


    func showNameValidationAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Имя не должно быть пустым и должно содержать как минимум 2 символа", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in

        }))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

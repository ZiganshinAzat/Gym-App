//
//  LoginViewController.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.05.2024.
//

import UIKit

class LoginViewController: UIViewController {

    private let loginView = LoginView()
    private let loginViewModel: LoginViewModel

    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = loginView
        loginView.viewModel = loginViewModel
        loginView.loginButtonAction = loginUser(_:_:)
        loginViewModel.onLoginSuccess = onLoginSuccess
        loginViewModel.onLoginFailure = onLoginFailure
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let navBarColor = UIColor(red: 0x93/255, green: 0x70/255, blue: 0xDB/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = navBarColor
    }
}

extension LoginViewController {

    func loginUser(_ email: String?, _ password: String?) {
        loginViewModel.loginUser(email, password)
    }

    func onLoginSuccess() {
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

    func onLoginFailure(error: Error) {
        print(error)
        showLoginFailedAlert()
    }

    func showLoginFailedAlert() {
        let alert = UIAlertController(
            title: "Ошибка входа",
            message: "Неверный email или пароль. Пожалуйста, попробуйте ещё раз.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in

        }))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

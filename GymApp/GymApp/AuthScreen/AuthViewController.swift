//
//  AuthViewController.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.05.2024.
//

import UIKit

class AuthViewController: UIViewController {

    private let authView = AuthView()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), tag: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = authView
        authView.signUpButtonAction = signUpButtonAction
        authView.logInButtonAction = logInButtonAction
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    func signUpButtonAction() {
        let registrationViewModel = RegistrationViewModel()
        self.navigationController?.pushViewController(RegistrationViewController(registrationViewModel: registrationViewModel), animated: true)
    }

    func logInButtonAction() {
        let loginViewModel = LoginViewModel()
        self.navigationController?.pushViewController(LoginViewController(loginViewModel: loginViewModel), animated: true)
    }
}

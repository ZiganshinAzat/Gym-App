//
//  LoginViewController.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.05.2024.
//

import UIKit

class ProfileViewController: UIViewController {

    private let profileView = ProfileView()
    private let profileViewModel: ProfileViewModel

    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), tag: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = profileView
        profileView.logoutButtonAction = showLogoutConfirmationAlert
        profileViewModel.onLogoutSuccess = navigateToAuth
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension ProfileViewController {
    private func showLogoutConfirmationAlert() {
        let alert = UIAlertController(title: "Выход", message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive, handler: { [weak self] _ in
            self?.profileViewModel.logoutUser()
        }))
        present(alert, animated: true, completion: nil)
    }

    private func navigateToAuth() {
        DispatchQueue.main.async {
            let authViewController = AuthViewController()

            if let tabBarController = self.tabBarController {
                if let navController = tabBarController.viewControllers?[1] as? UINavigationController {
                    navController.setViewControllers([authViewController], animated: true)
                    tabBarController.selectedIndex = 1
                }
            }
        }
    }
}

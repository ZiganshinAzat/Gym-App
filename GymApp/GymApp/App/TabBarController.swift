//
//  TabBarController.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.05.2024.
//

import UIKit
import FirebaseAuth

@MainActor
class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.backgroundColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)
        self.tabBar.barTintColor = UIColor(red: 0x08/255, green: 0x0A/255, blue: 0x17/255, alpha: 1.0)
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor(red: 0x93/255, green: 0x70/255, blue: 0xDB/255, alpha: 1.0)

        let trainingProgramsViewController = TrainingProgramsViewController(viewModel: TrainingProgramsViewModel())
        trainingProgramsViewController.tabBarItem = UITabBarItem(
            title: "Training",
            image: .trainingProgramsIcon,
            tag: 0
        )

        let trainingHistoryViewController = TrainingHistoryViewController(historyViewModel: TrainingHistoryViewModel())

        let foodSearchViewModel = FoodSearchViewModel(foodSearchService: TastyAPIService())
        let foodSearchViewController = FoodSearchViewController(foodSearchViewModel: foodSearchViewModel)

        Task {
            let profileViewController: UIViewController
            if await FirebaseAuthManager.shared.isUserAuthenticated() {
                profileViewController = ProfileViewController(profileViewModel: ProfileViewModel())
            } else {
                profileViewController = AuthViewController()
            }
            profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: .profile, tag: 3)

            self.viewControllers = [
                UINavigationController(rootViewController: trainingProgramsViewController),
                UINavigationController(rootViewController: trainingHistoryViewController),
                foodSearchViewController,
                UINavigationController(rootViewController: profileViewController)
            ]
        }
    }
}

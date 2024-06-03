//
//  LoginViewController.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.05.2024.
//

import UIKit
import Combine
import Kingfisher

class ProfileViewController: UIViewController {

    private let profileView = ProfileView()
    private let profileViewModel: ProfileViewModel
    private let imagePicker = UIImagePickerController()
    private var cancellables: Set<AnyCancellable> = []

    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), tag: 2)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = profileView
        profileView.logoutButtonAction = showLogoutConfirmationAlert
        profileViewModel.onLogoutSuccess = navigateToAuth
        profileView.avatarImageViewTapAction = selectAvatarImage
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)

        profileViewModel.fetchUserPhoto()
    }
}

extension ProfileViewController {
    private func setupBindings() {
        profileViewModel.$photoURL
            .sink { [weak self] url in
                guard let self else { return }

                DispatchQueue.main.async {
                    self.profileView.avatarImageView.kf.setImage(with: url)
                }
            }
            .store(in: &cancellables)
    }

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
                if let navController = tabBarController.viewControllers?[3] as? UINavigationController {
                    navController.setViewControllers([authViewController], animated: true)
                    tabBarController.selectedIndex = 3
                }
            }
        }
    }

    private func selectAvatarImage() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let editedImage = info[.editedImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }

        profileView.avatarImageView.image = editedImage

        Task {
            let imageData = editedImage.jpegData(compressionQuality: 0.8)!
            profileViewModel.uploadUserPhoto(imageData: imageData)
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

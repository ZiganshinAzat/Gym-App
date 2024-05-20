//
//  ProfileViewModel.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.05.2024.
//

import Foundation

class ProfileViewModel {
    
    private let firebaseAuthManager = FirebaseAuthManager.shared

    var onLogoutSuccess: (() -> Void)?

    func logoutUser() {
        Task {
            try await firebaseAuthManager.logoutUser()
            onLogoutSuccess?()
        }
    }
}

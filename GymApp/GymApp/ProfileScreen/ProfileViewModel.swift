//
//  ProfileViewModel.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.05.2024.
//

import Foundation

class ProfileViewModel {
    
    private let firebaseAuthManager = FirebaseAuthManager.shared
    private let cacheManager = CacheManager.shared

    var onLogoutSuccess: (() -> Void)?

    func logoutUser() {
        Task {
            try await firebaseAuthManager.logoutUser()

            UserDefaults.standard.removeObject(forKey: "userID")
            cacheManager.clearAllCache()

            onLogoutSuccess?()
        }
    }
}

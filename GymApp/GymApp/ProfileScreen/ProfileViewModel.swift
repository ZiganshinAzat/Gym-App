//
//  ProfileViewModel.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.05.2024.
//

import Foundation
import Combine

class ProfileViewModel {
    private let firebaseAuthManager = FirebaseAuthManager.shared
    private let firebaseStorageManager = FirebaseStorageManager.shared
    private let cacheManager = CacheManager.shared

    @Published var photoURL: URL?

    var onLogoutSuccess: (() -> Void)?

    func logoutUser() {
        Task {
            try await firebaseAuthManager.logoutUser()

            UserDefaults.standard.removeObject(forKey: "userID")
            cacheManager.clearAllCache()

            onLogoutSuccess?()
        }
    }

    func uploadUserPhoto(imageData: Data) {
        Task {
            guard let userID = await firebaseAuthManager.getAuthenticatedUserId() else {
                throw NSError(
                    domain: "TrainingProgramsViewModel",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]
                )
            }
            do {
                _ = try await firebaseStorageManager.uploadUserAvatar(uid: userID, imageData: imageData)
            } catch {
                print("Failed to upload photo: \(error.localizedDescription)")
            }
        }
    }

    func fetchUserPhoto() {
        Task {
            guard let userID = await firebaseAuthManager.getAuthenticatedUserId() else {
                let error = NSError(
                    domain: "ProfileViewModel",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]
                )
                return
            }
            do {
                if let photoURL = try await firebaseStorageManager.getUserAvatarURL(uid: userID) {
                    self.photoURL = photoURL
                    debugPrint(photoURL)
                } else {
                    _ = NSError(
                        domain: "ProfileViewModel",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Avatar not found"]
                    )
                }
            } catch {
                print("Failed to fetch photo: \(error.localizedDescription)")
            }
        }
    }}

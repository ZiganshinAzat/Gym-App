//
//  TrainingProgramsViewModel.swift
//  GymApp
//
//  Created by Азат Зиганшин on 10.03.2024.
//

import Foundation

class TrainingProgramsViewModel {
    
    private let firebaseAuthManager = FirebaseAuthManager.shared
    private let firebaseFirestoreManager = FirebaseFirestoreManager.shared

    func isUserAuthenticated() async -> Bool {
        return await firebaseAuthManager.isUserAuthenticated()
    }

    func fetchTrainingPrograms() async throws -> [TrainingProgram] {
        guard let userID = await firebaseAuthManager.getAuthenticatedUserId() else {
            throw NSError(domain: "TrainingProgramsViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        return try await firebaseFirestoreManager.fetchTrainingProgramsForUser(userID: userID)
    }
}

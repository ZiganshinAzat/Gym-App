//
//  TrainingProgramsViewModel.swift
//  GymApp
//
//  Created by Азат Зиганшин on 10.03.2024.
//

import Foundation
import Combine

class TrainingProgramsViewModel {
    
    private let firebaseAuthManager = FirebaseAuthManager.shared
    private let firebaseFirestoreManager = FirebaseFirestoreManager.shared
    private let cacheManager = CacheManager.shared

    @Published var trainingPrograms: [TrainingProgram] = []

    func isUserAuthenticated() async -> Bool {
        return await firebaseAuthManager.isUserAuthenticated()
    }

    func fetchTrainingPrograms() async throws {
        trainingPrograms = cacheManager.fetchTrainingPrograms()

        guard let userID = await firebaseAuthManager.getAuthenticatedUserId() else {
            throw NSError(domain: "TrainingProgramsViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        let fetchedPrograms = try await firebaseFirestoreManager.fetchTrainingProgramsForUser(userID: userID)

        trainingPrograms = fetchedPrograms
        cacheManager.cacheTrainingPrograms(trainingPrograms)
    }
}

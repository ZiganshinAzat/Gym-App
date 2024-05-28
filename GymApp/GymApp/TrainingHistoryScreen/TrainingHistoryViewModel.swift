//
//  TrainingHistoryViewModel.swift
//  GymApp
//
//  Created by Азат Зиганшин on 23.05.2024.
//

import Foundation
import Combine

class TrainingHistoryViewModel {
    
    private let firebaseAuthManager = FirebaseAuthManager.shared
    private let firebaseFirestoreManager = FirebaseFirestoreManager.shared
    private let cacheService = CacheManager.shared

    @Published var trainingHistories: [TrainingHistory] = []
    @Published var trainingPrograms: [String: TrainingProgram] = [:]

    func fetchTrainingHistories() async throws {
        guard let userID = await firebaseAuthManager.getAuthenticatedUserId() else {
            throw NSError(domain: "TrainingProgramsViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        let fetchedHistories = try await firebaseFirestoreManager.fetchTrainingHistoriesForUser(userID: userID)
        let programIDs = Set(fetchedHistories.map { $0.trainingProgramID })

        var fetchedPrograms: [String: TrainingProgram] = [:]
        for programID in programIDs {
            let trainingProgram = try await firebaseFirestoreManager.fetchTrainingProgramByID(programID)
            fetchedPrograms[programID] = trainingProgram
        }

        trainingHistories = fetchedHistories
        trainingPrograms = fetchedPrograms
    }
}

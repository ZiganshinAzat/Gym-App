//
//  AddTrainingViewModel.swift
//  GymApp
//
//  Created by Азат Зиганшин on 10.03.2024.
//

import Foundation

class AddTrainingViewModel {
    
    private let firebaseFirestoreManager = FirebaseFirestoreManager.shared
    private let firebaseAuthManager = FirebaseAuthManager.shared

    var onValidationError: (() -> Void)?
    var onValidationSuccess: (() -> Void)?
    var onSavingSuccess: (() -> Void)?

    func saveTrainingProgram(trainingProgram: TrainingProgram) {
        Task {
            do {
                try await firebaseFirestoreManager.saveTrainingProgramToDatabase(trainingProgram)
                onSavingSuccess?()
                print("Training program saved successfully")
            } catch {
                print("Failed to save training program: \(error)")
            }
        }
    }

    func getAuthenticatedUserId() async -> String? {
        return await firebaseAuthManager.getAuthenticatedUserId()
    }

    func validate(trainingTitle: String?) -> Bool {
        if let title = trainingTitle, !title.isEmpty {
            onValidationSuccess?()
            return true
        } else {
            onValidationError?()
            return false
        }
    }
}

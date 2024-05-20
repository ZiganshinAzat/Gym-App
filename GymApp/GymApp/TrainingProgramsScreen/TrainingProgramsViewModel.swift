//
//  TrainingProgramsViewModel.swift
//  GymApp
//
//  Created by Азат Зиганшин on 10.03.2024.
//

import Foundation

class TrainingProgramsViewModel {
    
    private let firebaseAuthManager = FirebaseAuthManager.shared

    func isUserAuthenticated() async -> Bool {
        return await firebaseAuthManager.isUserAuthenticated()
    }
}

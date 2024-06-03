//
//  TrainingHistory.swift
//  GymApp
//
//  Created by Азат Зиганшин on 21.05.2024.
//

import Foundation

struct TrainingHistory {
    var id: String
    var userID: String
    var date: Date
    var trainingProgramID: String
    var exerciseHistories: [ExerciseHistory]
}

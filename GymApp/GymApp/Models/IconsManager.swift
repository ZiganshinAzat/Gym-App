//
//  IconsManager.swift
//  GymApp
//
//  Created by Азат Зиганшин on 27.03.2024.
//

import Foundation
import UIKit

class IconsManager {

    static let shared = IconsManager()

    private init() { }

    private let trainingProgramsIcons: [String] = [
        "upperBodyGradient",
        "lowerBodyGradient",
        "fullBodyGradient"
    ]
    private let muscleGroupsIcons: [String] = [
        "shoulder",
        "back1",
        "back2",
        "chest",
        "front",
        "glutes"
    ]

    func getTrainingProgramsIcons() -> [String] {
        trainingProgramsIcons
    }

    func getMuscleGroupsIcons() -> [String] {
        muscleGroupsIcons
    }
}

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
        "chest",
        "back",
        "shoulder",
        "front1",
        "press1",
        "biceps",
        "triceps",
        "glutes",
        "back1",
        "back2",
        "back3",
        "back4",
        "back5",
        "back6",
        "exercise1",
        "front2",
        "muscles2",
        "muscles3",
        "muscles4",
        "neck",
        "press2",
        "press3",
        "training",
        "arms"
    ]

    func getTrainingProgramsIcons() -> [String] {
        trainingProgramsIcons
    }

    func getMuscleGroupsIcons() -> [String] {
        muscleGroupsIcons
    }
}

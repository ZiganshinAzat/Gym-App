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

    private let trainingProgramsIcons: [UIImage?] = [
        UIImage(named: "upperBodyGradient"),
        UIImage(named: "lowerBodyGradient"),
        UIImage(named: "fullBodyGradient")
    ]
    private let muscleGroupsIcons: [UIImage?] = []

    func getTrainingProgramsIcons() -> [UIImage?] {
        trainingProgramsIcons
    }

    func getMuscleGroupsIcons() -> [UIImage?] {
        muscleGroupsIcons
    }
}

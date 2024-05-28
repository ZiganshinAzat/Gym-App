//
//  NSManagedObjectContext.swift
//  GymApp
//
//  Created by Азат Зиганшин on 27.05.2024.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func createTrainingProgram(from trainingProgram: TrainingProgram) -> TrainingProgramCoreData {
        let trainingProgramCoreData = TrainingProgramCoreData(context: self)
        trainingProgramCoreData.id = trainingProgram.id
        trainingProgramCoreData.name = trainingProgram.name
        trainingProgramCoreData.image = trainingProgram.image
        trainingProgramCoreData.userID = trainingProgram.userID

        let exercisesCoreData = trainingProgram.exercises.map { self.createExercise(from: $0) }
        trainingProgramCoreData.exercises = NSOrderedSet(array: exercisesCoreData)

        return trainingProgramCoreData
    }

    func createExercise(from exercise: Exercise) -> ExerciseCoreData {
        let exerciseCoreData = ExerciseCoreData(context: self)
        exerciseCoreData.id = exercise.id
        exerciseCoreData.name = exercise.name
        exerciseCoreData.image = exercise.image
        exerciseCoreData.index = Int16(exercise.index)
        return exerciseCoreData
    }
}


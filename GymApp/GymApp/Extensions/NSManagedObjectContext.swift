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

extension NSManagedObjectContext {
    func createTrainingHistory(from trainingHistory: TrainingHistory) -> TrainingHistoryCoreData {
        let trainingHistoryCoreData = TrainingHistoryCoreData(context: self)
        trainingHistoryCoreData.id = trainingHistory.id
        trainingHistoryCoreData.userID = trainingHistory.userID
        trainingHistoryCoreData.date = trainingHistory.date
        trainingHistoryCoreData.trainingProgramID = trainingHistory.trainingProgramID

        let exerciseHistoriesCoreData = trainingHistory.exerciseHistories.map { self.createExerciseHistory(from: $0) }
        trainingHistoryCoreData.exerciseHistories = NSOrderedSet(array: exerciseHistoriesCoreData)

        return trainingHistoryCoreData
    }

    func createExerciseHistory(from exerciseHistory: ExerciseHistory) -> ExerciseHistoryCoreData {
        let exerciseHistoryCoreData = ExerciseHistoryCoreData(context: self)
        exerciseHistoryCoreData.id = exerciseHistory.id
        exerciseHistoryCoreData.exerciseID = exerciseHistory.exerciseID

        let setsCoreData = exerciseHistory.sets.map { self.createExerciseSet(from: $0) }
        exerciseHistoryCoreData.sets = NSOrderedSet(array: setsCoreData)

        return exerciseHistoryCoreData
    }

    func createExerciseSet(from exerciseSet: ExerciseSet) -> ExerciseSetCoreData {
        let exerciseSetCoreData = ExerciseSetCoreData(context: self)
        exerciseSetCoreData.weight = Int16(exerciseSet.weight)
        exerciseSetCoreData.repetitions = Int16(exerciseSet.repetitions)
        exerciseSetCoreData.index = Int16(exerciseSet.index)
        return exerciseSetCoreData
    }
}

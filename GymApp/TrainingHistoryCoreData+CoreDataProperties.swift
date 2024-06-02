//
//  TrainingHistoryCoreData+CoreDataProperties.swift
//  GymApp
//
//  Created by Азат Зиганшин on 29.05.2024.
//
//

import Foundation
import CoreData


extension TrainingHistoryCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingHistoryCoreData> {
        return NSFetchRequest<TrainingHistoryCoreData>(entityName: "TrainingHistoryCoreData")
    }

    @NSManaged public var date: Date
    @NSManaged public var id: String
    @NSManaged public var trainingProgramID: String
    @NSManaged public var userID: String
    @NSManaged public var exerciseHistories: NSOrderedSet

}

// MARK: Generated accessors for exerciseHistories
extension TrainingHistoryCoreData {

    @objc(insertObject:inExerciseHistoriesAtIndex:)
    @NSManaged public func insertIntoExerciseHistories(_ value: ExerciseHistoryCoreData, at idx: Int)

    @objc(removeObjectFromExerciseHistoriesAtIndex:)
    @NSManaged public func removeFromExerciseHistories(at idx: Int)

    @objc(insertExerciseHistories:atIndexes:)
    @NSManaged public func insertIntoExerciseHistories(_ values: [ExerciseHistoryCoreData], at indexes: NSIndexSet)

    @objc(removeExerciseHistoriesAtIndexes:)
    @NSManaged public func removeFromExerciseHistories(at indexes: NSIndexSet)

    @objc(replaceObjectInExerciseHistoriesAtIndex:withObject:)
    @NSManaged public func replaceExerciseHistories(at idx: Int, with value: ExerciseHistoryCoreData)

    @objc(replaceExerciseHistoriesAtIndexes:withExerciseHistories:)
    @NSManaged public func replaceExerciseHistories(at indexes: NSIndexSet, with values: [ExerciseHistoryCoreData])

    @objc(addExerciseHistoriesObject:)
    @NSManaged public func addToExerciseHistories(_ value: ExerciseHistoryCoreData)

    @objc(removeExerciseHistoriesObject:)
    @NSManaged public func removeFromExerciseHistories(_ value: ExerciseHistoryCoreData)

    @objc(addExerciseHistories:)
    @NSManaged public func addToExerciseHistories(_ values: NSOrderedSet)

    @objc(removeExerciseHistories:)
    @NSManaged public func removeFromExerciseHistories(_ values: NSOrderedSet)

}

extension TrainingHistoryCoreData : Identifiable {

}

extension TrainingHistoryCoreData {
    func toTrainingHistory() -> TrainingHistory {
        let exerciseHistoriesArray = (self.exerciseHistories.array as? [ExerciseHistoryCoreData])?.map { $0.toExerciseHistory() } ?? []
        return TrainingHistory(
            id: self.id,
            userID: self.userID,
            date: self.date,
            trainingProgramID: self.trainingProgramID,
            exerciseHistories: exerciseHistoriesArray
        )
    }
}

//
//  TrainingProgramCoreData+CoreDataProperties.swift
//  GymApp
//
//  Created by Азат Зиганшин on 27.05.2024.
//
//

import Foundation
import CoreData

extension TrainingProgramCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingProgramCoreData> {
        return NSFetchRequest<TrainingProgramCoreData>(entityName: "TrainingProgramCoreData")
    }

    @NSManaged public var id: String
    @NSManaged public var image: String
    @NSManaged public var name: String
    @NSManaged public var userID: String
    @NSManaged public var exercises: NSOrderedSet

}

// MARK: Generated accessors for exercises
extension TrainingProgramCoreData {

    @objc(insertObject:inExercisesAtIndex:)
    @NSManaged public func insertIntoExercises(_ value: ExerciseCoreData, at idx: Int)

    @objc(removeObjectFromExercisesAtIndex:)
    @NSManaged public func removeFromExercises(at idx: Int)

    @objc(insertExercises:atIndexes:)
    @NSManaged public func insertIntoExercises(_ values: [ExerciseCoreData], at indexes: NSIndexSet)

    @objc(removeExercisesAtIndexes:)
    @NSManaged public func removeFromExercises(at indexes: NSIndexSet)

    @objc(replaceObjectInExercisesAtIndex:withObject:)
    @NSManaged public func replaceExercises(at idx: Int, with value: ExerciseCoreData)

    @objc(replaceExercisesAtIndexes:withExercises:)
    @NSManaged public func replaceExercises(at indexes: NSIndexSet, with values: [ExerciseCoreData])

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: ExerciseCoreData)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: ExerciseCoreData)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSOrderedSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSOrderedSet)

}

extension TrainingProgramCoreData: Identifiable {

}

extension TrainingProgramCoreData {
    func toTrainingProgram() -> TrainingProgram {
        let exercisesArray = (self.exercises.array as? [ExerciseCoreData])?.map { $0.toExercise() } ?? []
        return TrainingProgram(
            id: self.id,
            name: self.name,
            image: self.image,
            userID: self.userID,
            exercises: exercisesArray
        )
    }
}

//
//  ExerciseHistoryCoreData+CoreDataProperties.swift
//  GymApp
//
//  Created by Азат Зиганшин on 29.05.2024.
//
//

import Foundation
import CoreData


extension ExerciseHistoryCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseHistoryCoreData> {
        return NSFetchRequest<ExerciseHistoryCoreData>(entityName: "ExerciseHistoryCoreData")
    }

    @NSManaged public var exerciseID: String
    @NSManaged public var id: String
    @NSManaged public var sets: NSOrderedSet
//    @NSManaged public var trainingHistory: TrainingHistoryCoreData?

}

// MARK: Generated accessors for sets
extension ExerciseHistoryCoreData {

    @objc(insertObject:inSetsAtIndex:)
    @NSManaged public func insertIntoSets(_ value: ExerciseSetCoreData, at idx: Int)

    @objc(removeObjectFromSetsAtIndex:)
    @NSManaged public func removeFromSets(at idx: Int)

    @objc(insertSets:atIndexes:)
    @NSManaged public func insertIntoSets(_ values: [ExerciseSetCoreData], at indexes: NSIndexSet)

    @objc(removeSetsAtIndexes:)
    @NSManaged public func removeFromSets(at indexes: NSIndexSet)

    @objc(replaceObjectInSetsAtIndex:withObject:)
    @NSManaged public func replaceSets(at idx: Int, with value: ExerciseSetCoreData)

    @objc(replaceSetsAtIndexes:withSets:)
    @NSManaged public func replaceSets(at indexes: NSIndexSet, with values: [ExerciseSetCoreData])

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: ExerciseSetCoreData)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: ExerciseSetCoreData)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSOrderedSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSOrderedSet)

}

extension ExerciseHistoryCoreData : Identifiable {

}

extension ExerciseHistoryCoreData {
    func toExerciseHistory() -> ExerciseHistory {
        let setsArray = (self.sets.array as? [ExerciseSetCoreData])?.map { $0.toExerciseSet() } ?? []
        return ExerciseHistory(
            id: self.id,
            exerciseID: self.exerciseID,
            sets: setsArray
        )
    }
}

//
//  ExerciseSetCoreData+CoreDataProperties.swift
//  GymApp
//
//  Created by Азат Зиганшин on 29.05.2024.
//
//

import Foundation
import CoreData

extension ExerciseSetCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseSetCoreData> {
        return NSFetchRequest<ExerciseSetCoreData>(entityName: "ExerciseSetCoreData")
    }

    @NSManaged public var index: Int16
    @NSManaged public var repetitions: Int16
    @NSManaged public var weight: Int16
//    @NSManaged public var exerciseHistory: ExerciseHistoryCoreData?

}

extension ExerciseSetCoreData: Identifiable {

}

extension ExerciseSetCoreData {
    func toExerciseSet() -> ExerciseSet {
        return ExerciseSet(
            weight: Int(self.weight),
            repetitions: Int(self.repetitions),
            index: Int(self.index)
        )
    }
}

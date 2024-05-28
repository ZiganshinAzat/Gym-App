//
//  ExerciseCoreData+CoreDataProperties.swift
//  GymApp
//
//  Created by Азат Зиганшин on 27.05.2024.
//
//

import Foundation
import CoreData


extension ExerciseCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseCoreData> {
        return NSFetchRequest<ExerciseCoreData>(entityName: "ExerciseCoreData")
    }

    @NSManaged public var index: Int16
    @NSManaged public var image: String
    @NSManaged public var name: String
    @NSManaged public var id: String
//    @NSManaged public var trainingProgram: TrainingProgramCoreData

}

extension ExerciseCoreData : Identifiable {

}

extension ExerciseCoreData {
    func toExercise() -> Exercise {
        return Exercise(
            id: self.id,
            name: self.name,
            image: self.image,
            index: Int(self.index)
        )
    }
}

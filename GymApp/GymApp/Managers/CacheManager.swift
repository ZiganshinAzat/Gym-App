//
//  CacheService.swift
//  GymApp
//
//  Created by Азат Зиганшин on 27.05.2024.
//

import Foundation
import CoreData

class CacheManager {
    static let shared = CacheManager()

    private init() {}

    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GymAppModels")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchTrainingPrograms() -> [TrainingProgram] {
        let fetchRequest: NSFetchRequest<TrainingProgramCoreData> = TrainingProgramCoreData.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { $0.toTrainingProgram() }
        } catch {
            print("Failed to fetch training programs: \(error)")
            return []
        }
    }

    func fetchTrainingPrograms(forUserID userID: String) -> [TrainingProgram] {
        let fetchRequest: NSFetchRequest<TrainingProgramCoreData> = TrainingProgramCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { $0.toTrainingProgram() }
        } catch {
            print("Failed to fetch training programs for user \(userID): \(error)")
            return []
        }
    }

    func fetchExercises() -> [Exercise] {
        let fetchRequest: NSFetchRequest<ExerciseCoreData> = ExerciseCoreData.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { $0.toExercise() }
        } catch {
            print("Failed to fetch exercises: \(error)")
            return []
        }
    }

    func addTrainingProgramToCache(_ trainingProgram: TrainingProgram) {
        _ = self.context.createTrainingProgram(from: trainingProgram)
        saveContext()
    }

    func cacheTrainingPrograms(_ trainingPrograms: [TrainingProgram]) {
        clearTrainingProgramsCache()
        trainingPrograms.forEach { trainingProgram in
            _ = self.context.createTrainingProgram(from: trainingProgram)
        }
        saveContext()
    }

    func clearTrainingProgramsCache() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TrainingProgramCoreData.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Failed to clear training programs cache: \(error)")
        }
    }

    func fetchTrainingHistories() -> [TrainingHistory] {
        let fetchRequest: NSFetchRequest<TrainingHistoryCoreData> = TrainingHistoryCoreData.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { $0.toTrainingHistory() }
        } catch {
            print("Failed to fetch training histories: \(error)")
            return []
        }
    }

    func fetchTrainingHistories(forUserID userID: String) -> [TrainingHistory] {
        let fetchRequest: NSFetchRequest<TrainingHistoryCoreData> = TrainingHistoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { $0.toTrainingHistory() }
        } catch {
            print("Failed to fetch training histories for user \(userID): \(error)")
            return []
        }
    }

    func addTrainingHistoryToCache(_ trainingHistory: TrainingHistory) {
        _ = self.context.createTrainingHistory(from: trainingHistory)
        saveContext()
    }

    func cacheTrainingHistories(_ trainingHistories: [TrainingHistory]) {
        clearTrainingHistoriesCache()
        trainingHistories.forEach { trainingHistory in
            _ = self.context.createTrainingHistory(from: trainingHistory)
        }
        saveContext()
    }

    func clearTrainingHistoriesCache() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TrainingHistoryCoreData.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Failed to clear training histories cache: \(error)")
        }
    }

    func clearAllCache() {
        clearTrainingProgramsCache()
        clearTrainingHistoriesCache()
    }
}

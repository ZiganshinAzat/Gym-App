import Foundation
import CoreData

class CacheManager {
    static let shared = CacheManager()

    private init() {}

    private var isSaving = false

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

    lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        return context
    }()

    func saveContext(context: NSManagedObjectContext) {
        context.perform {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
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
        backgroundContext.perform {
            _ = self.backgroundContext.createTrainingProgram(from: trainingProgram)
            self.saveContext(context: self.backgroundContext)
        }
    }

    func cacheTrainingPrograms(_ trainingPrograms: [TrainingProgram]) {
        clearTrainingProgramsCache {
            self.backgroundContext.perform {
                trainingPrograms.forEach { trainingProgram in
                    _ = self.backgroundContext.createTrainingProgram(from: trainingProgram)
                }
                self.saveContext(context: self.backgroundContext)
            }
        }
    }

    func clearTrainingProgramsCache(completion: (() -> Void)? = nil) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TrainingProgramCoreData.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        backgroundContext.perform {
            do {
                try self.backgroundContext.execute(deleteRequest)
                self.saveContext(context: self.backgroundContext)
                completion?()
            } catch {
                print("Failed to clear training programs cache: \(error)")
                completion?()
            }
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
        backgroundContext.perform {
            _ = self.backgroundContext.createTrainingHistory(from: trainingHistory)
            self.saveContext(context: self.backgroundContext)
        }
    }

    func cacheTrainingHistories(_ trainingHistories: [TrainingHistory]) {
        clearTrainingHistoriesCache {
            self.backgroundContext.perform {
                trainingHistories.forEach { trainingHistory in
                    _ = self.backgroundContext.createTrainingHistory(from: trainingHistory)
                }
                self.saveContext(context: self.backgroundContext)
            }
        }
    }

    func clearTrainingHistoriesCache(completion: (() -> Void)? = nil) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TrainingHistoryCoreData.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        backgroundContext.perform {
            do {
                try self.backgroundContext.execute(deleteRequest)
                self.saveContext(context: self.backgroundContext)
                completion?()
            } catch {
                print("Failed to clear training histories cache: \(error)")
                completion?()
            }
        }
    }

    func clearAllCache() {
        clearTrainingProgramsCache()
        clearTrainingHistoriesCache()
    }
}

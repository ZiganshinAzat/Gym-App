import Foundation
import Combine

class TrainingHistoryViewModel {

    private let firebaseAuthManager = FirebaseAuthManager.shared
    private let firebaseFirestoreManager = FirebaseFirestoreManager.shared
    private let cacheManager = CacheManager.shared

    @Published var trainingHistories: [TrainingHistory] = []
    var trainingPrograms: [String: TrainingProgram] = [:]

    func fetchTrainingHistories() async throws {
        guard let userID = UserDefaults.standard.string(forKey: "userID") else {
            throw NSError(domain: "TrainingProgramsViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }

        // Fetch cached programs
        let cachedPrograms = cacheManager.fetchTrainingPrograms(forUserID: userID)
        var cachedProgramDict: [String: TrainingProgram] = [:]
        for program in cachedPrograms {
            cachedProgramDict[program.id] = program
        }
        self.trainingPrograms = cachedProgramDict

        // Fetch cached histories and sort by date
        var cachedHistories = cacheManager.fetchTrainingHistories(forUserID: userID)
        cachedHistories.sort { $0.date > $1.date }
        self.trainingHistories = cachedHistories

        // Fetch updated histories from Firebase
        guard let userID = await firebaseAuthManager.getAuthenticatedUserId() else {
            throw NSError(domain: "TrainingProgramsViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }

        let fetchedHistories = try await firebaseFirestoreManager.fetchTrainingHistoriesForUser(userID: userID)
        let programIDs = Set(fetchedHistories.map { $0.trainingProgramID })

        // Fetch missing programs
        let missingProgramIDs = programIDs.filter { cachedProgramDict[$0] == nil }
        var fetchedPrograms: [String: TrainingProgram] = [:]
        for programID in missingProgramIDs {
            let trainingProgram = try await firebaseFirestoreManager.fetchTrainingProgramByID(programID)
            fetchedPrograms[programID] = trainingProgram
        }

        self.trainingPrograms.merge(fetchedPrograms) { (current, _) in current }

        // Sort fetched histories by date and update the published property
        var sortedFetchedHistories = fetchedHistories
        sortedFetchedHistories.sort { $0.date > $1.date }
        self.trainingHistories = sortedFetchedHistories

        // Cache updated training histories
        cacheManager.cacheTrainingHistories(sortedFetchedHistories)
    }
}

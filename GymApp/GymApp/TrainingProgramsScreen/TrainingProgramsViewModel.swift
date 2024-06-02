import Foundation
import Combine

class TrainingProgramsViewModel {

    private let firebaseAuthManager = FirebaseAuthManager.shared
    private let firebaseFirestoreManager = FirebaseFirestoreManager.shared
    private let cacheManager = CacheManager.shared

    @Published var trainingPrograms: [TrainingProgram] = []

    func isUserAuthenticated() async -> Bool {
        return await firebaseAuthManager.isUserAuthenticated()
    }

    func fetchTrainingPrograms() async throws {
        guard let userID = UserDefaults.standard.string(forKey: "userID") else {
            throw NSError(domain: "TrainingProgramsViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }

        var cachedPrograms = cacheManager.fetchTrainingPrograms(forUserID: userID)
        cachedPrograms.sort {
            if $0.image == $1.image {
                return $0.name < $1.name
            }
            return $0.image < $1.image
        }
        self.trainingPrograms = cachedPrograms

        guard let fetchedUserID = await firebaseAuthManager.getAuthenticatedUserId() else {
            throw NSError(domain: "TrainingProgramsViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }

        var fetchedPrograms = try await firebaseFirestoreManager.fetchTrainingProgramsForUser(userID: fetchedUserID)
        fetchedPrograms.sort {
            if $0.image == $1.image {
                return $0.name < $1.name
            }
            return $0.image < $1.image
        }
        UserDefaults.standard.set(fetchedUserID, forKey: "userID")

        self.trainingPrograms = fetchedPrograms
        cacheManager.cacheTrainingPrograms(fetchedPrograms)
    }
}

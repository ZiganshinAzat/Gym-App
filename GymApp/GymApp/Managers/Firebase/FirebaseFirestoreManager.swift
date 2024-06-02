import Foundation
import FirebaseFirestore

actor FirebaseFirestoreManager {

    static let shared = FirebaseFirestoreManager()

    private let database = Firestore.firestore()

    private init() {}

    func saveUserToDatabase(_ user: User) async throws {
        let userRef = database.collection("users").document(user.uid)
        let data: [String: Any] = [
            "username": user.username,
            "profilePictureURL": user.profilePictureURL ?? ""
        ]
        try await userRef.setData(data)
    }

    func fetchUserFromDatabase(uid: String) async throws -> User {
        let userRef = database.collection("users").document(uid)
        let document = try await userRef.getDocument()

        guard let data = document.data(),
              let username = data["username"] as? String else {
            throw NSError(
                domain: "FirebaseFirestoreManager",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to fetch user data"]
            )
        }

        let profilePictureURL = data["profilePictureURL"] as? String
        return User(uid: uid, username: username, profilePictureURL: profilePictureURL)
    }

    func saveTrainingProgramToDatabase(_ trainingProgram: TrainingProgram) async throws {
        let trainingProgramRef = database.collection("trainingPrograms").document(trainingProgram.id)

        let exercisesData: [[String: Any]] = trainingProgram.exercises.map { exercise in
            return [
                "id": exercise.id,
                "name": exercise.name,
                "index": exercise.index,
                "image": exercise.image
            ]
        }

        let data: [String: Any] = [
            "name": trainingProgram.name,
            "image": trainingProgram.image,
            "userID": trainingProgram.userID,
            "exercises": exercisesData
        ]

        try await trainingProgramRef.setData(data)
    }

    func fetchTrainingProgramsForUser(userID: String) async throws -> [TrainingProgram] {
        let trainingProgramsRef = database.collection("trainingPrograms").whereField("userID", isEqualTo: userID)
        let querySnapshot = try await trainingProgramsRef.getDocuments()

        var trainingPrograms: [TrainingProgram] = []

        for document in querySnapshot.documents {
            let data = document.data()

            guard let name = data["name"] as? String,
                  let image = data["image"] as? String,
                  let userID = data["userID"] as? String,
                  let exercisesData = data["exercises"] as? [[String: Any]] else {
                throw NSError(
                    domain: "FirebaseFirestoreManager",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to fetch training program data"]
                )
            }

            let exercises: [Exercise] = exercisesData.compactMap { exerciseData in
                guard let id = exerciseData["id"] as? String,
                      let name = exerciseData["name"] as? String,
                      let index = exerciseData["index"] as? Int,
                      let image = exerciseData["image"] as? String else {
                    return nil
                }
                return Exercise(id: id, name: name, image: image, index: index)
            }

            let trainingProgram = TrainingProgram(
                id: document.documentID,
                name: name,
                image: image,
                userID: userID,
                exercises: exercises
            )
            trainingPrograms.append(trainingProgram)
        }

        return trainingPrograms
    }

    func saveTrainingHistoryToDatabase(_ trainingHistory: TrainingHistory) async throws {
        let trainingHistoryRef = database.collection("trainingHistories").document(trainingHistory.id)

        let exerciseHistoriesData: [[String: Any]] = trainingHistory.exerciseHistories.map { exerciseHistory in
            let setsData: [[String: Any]] = exerciseHistory.sets.map { set in
                return [
                    "weight": set.weight,
                    "repetitions": set.repetitions,
                    "index": set.index
                ]
            }
            return [
                "id": exerciseHistory.id,
                "exerciseID": exerciseHistory.exerciseID,
                "sets": setsData
            ]
        }

        let dateString = ISO8601DateFormatter().string(from: trainingHistory.date)

        let data: [String: Any] = [
            "userID": trainingHistory.userID,
            "date": dateString,
            "trainingProgramID": trainingHistory.trainingProgramID,
            "exerciseHistories": exerciseHistoriesData
        ]

        try await trainingHistoryRef.setData(data)
    }

    func fetchTrainingHistoriesForUser(userID: String) async throws -> [TrainingHistory] {
        let trainingHistoriesRef = database.collection("trainingHistories").whereField("userID", isEqualTo: userID)
        let querySnapshot = try await trainingHistoriesRef.getDocuments()

        var trainingHistories: [TrainingHistory] = []

        for document in querySnapshot.documents {
            let data = document.data()

            guard let userID = data["userID"] as? String,
                  let dateString = data["date"] as? String,
                  let date = ISO8601DateFormatter().date(from: dateString),
                  let trainingProgramID = data["trainingProgramID"] as? String,
                  let exerciseHistoriesData = data["exerciseHistories"] as? [[String: Any]] else {
                print("Failed to parse training history data for document: \(document.documentID)")
                throw NSError(
                    domain: "FirebaseFirestoreManager",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to fetch training history data"]
                )
            }

            let exerciseHistories: [ExerciseHistory] = exerciseHistoriesData.compactMap { exerciseHistoryData in
                guard let id = exerciseHistoryData["id"] as? String,
                      let exerciseID = exerciseHistoryData["exerciseID"] as? String,
                      let setsData = exerciseHistoryData["sets"] as? [[String: Any]] else {
                    print("Failed to parse exercise history data: \(exerciseHistoryData)")
                    return nil
                }

                let sets: [ExerciseSet] = setsData.compactMap { setData in
                    guard let weight = setData["weight"] as? Int,
                          let repetitions = setData["repetitions"] as? Int,
                          let index = setData["index"] as? Int else {
                        print("Failed to parse set data: \(setData)")
                        return nil
                    }
                    return ExerciseSet(weight: weight, repetitions: repetitions, index: index)
                }

                return ExerciseHistory(id: id, exerciseID: exerciseID, sets: sets)
            }

            let trainingHistory = TrainingHistory(
                id: document.documentID,
                userID: userID,
                date: date,
                trainingProgramID: trainingProgramID,
                exerciseHistories: exerciseHistories
            )
            trainingHistories.append(trainingHistory)
        }

        return trainingHistories
    }

    func fetchTrainingProgramByID(_ id: String) async throws -> TrainingProgram {
        let trainingProgramRef = database.collection("trainingPrograms").document(id)
        let document = try await trainingProgramRef.getDocument()

        guard let data = document.data(),
              let name = data["name"] as? String,
              let image = data["image"] as? String,
              let userID = data["userID"] as? String,
              let exercisesData = data["exercises"] as? [[String: Any]] else {
            throw NSError(domain: "FirebaseFirestoreManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch training program data"])
        }

        let exercises: [Exercise] = exercisesData.compactMap { exerciseData in
            guard let id = exerciseData["id"] as? String,
                  let name = exerciseData["name"] as? String,
                  let index = exerciseData["index"] as? Int,
                  let image = exerciseData["image"] as? String else {
                return nil
            }
            return Exercise(id: id, name: name, image: image, index: index)
        }

        return TrainingProgram(id: document.documentID, name: name, image: image, userID: userID, exercises: exercises)
    }
}

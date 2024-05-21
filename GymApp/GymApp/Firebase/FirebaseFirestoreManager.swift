import Foundation
import FirebaseFirestore

actor FirebaseFirestoreManager {

    static let shared = FirebaseFirestoreManager()

    private let db = Firestore.firestore()

    private init() {}

    func saveUserToDatabase(_ user: User) async throws {
        let userRef = db.collection("users").document(user.uid)
        let data: [String: Any] = [
            "username": user.username,
            "profilePictureURL": user.profilePictureURL ?? ""
        ]
        try await userRef.setData(data)
    }

    func fetchUserFromDatabase(uid: String) async throws -> User {
        let userRef = db.collection("users").document(uid)
        let document = try await userRef.getDocument()

        guard let data = document.data(),
              let username = data["username"] as? String else {
            throw NSError(domain: "FirebaseFirestoreManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch user data"])
        }

        let profilePictureURL = data["profilePictureURL"] as? String
        return User(uid: uid, username: username, profilePictureURL: profilePictureURL)
    }

    func saveTrainingProgramToDatabase(_ trainingProgram: TrainingProgram) async throws {
        let trainingProgramRef = db.collection("trainingPrograms").document(trainingProgram.id)

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
        let trainingProgramsRef = db.collection("trainingPrograms").whereField("userID", isEqualTo: userID)
        let querySnapshot = try await trainingProgramsRef.getDocuments()

        var trainingPrograms: [TrainingProgram] = []

        for document in querySnapshot.documents {
            let data = document.data()

            guard let name = data["name"] as? String,
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
                return Exercise(id: id, name: name,  image: image, index: index)
            }

            let trainingProgram = TrainingProgram(id: document.documentID, name: name, image: image, userID: userID, exercises: exercises)
            trainingPrograms.append(trainingProgram)
        }

        return trainingPrograms
    }
}

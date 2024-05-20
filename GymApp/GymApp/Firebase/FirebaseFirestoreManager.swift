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
}

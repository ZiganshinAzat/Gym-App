import Foundation
import FirebaseAuth
import FirebaseDatabase

actor FirebaseAuthManager {

    static let shared = FirebaseAuthManager()

    private init() {}

    func registerUser(email: String, password: String, username: String) async throws -> User {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let uid = authResult.user.uid

        let user = User(uid: uid, username: username, profilePictureURL: nil)
        try await FirebaseFirestoreManager.shared.saveUserToDatabase(user)
        return user
    }

    func loginUser(email: String, password: String) async throws -> User {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let uid = authResult.user.uid

        let user = try await FirebaseFirestoreManager.shared.fetchUserFromDatabase(uid: uid)
        return user
    }

    func isUserAuthenticated() async -> Bool {
        return Auth.auth().currentUser != nil
    }

    func logoutUser() async throws {
        try Auth.auth().signOut()
    }
}

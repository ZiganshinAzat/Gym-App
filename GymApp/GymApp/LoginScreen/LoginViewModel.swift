//
//  LoginViewModel.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.05.2024.
//

import Foundation

class LoginViewModel {

    var onValidationError: ((ValidationError) -> Void)?
    var onValidationSuccess: ((ValidationError) -> Void)?
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((Error) -> Void)?

    private let firebaseAuthManager = FirebaseAuthManager.shared

    func loginUser(_ email: String?, _ password: String?) {
        guard validate(email: email, password: password) else {
            return
        }

        guard let email = email, let password = password else {
            return
        }

        Task {
            do {
                _ = try await firebaseAuthManager.loginUser(email: email, password: password)
                onLoginSuccess?()
            } catch {
                onLoginFailure?(error)
            }
        }
    }

    func validate(email: String?, password: String?) -> Bool {
        var isValid = true

        if let email = email, !email.isEmpty {
            onValidationSuccess?(.email)
        } else {
            isValid = false
            onValidationError?(.email)
        }

        if let password = password, !password.isEmpty {
            onValidationSuccess?(.password)
        } else {
            isValid = false
            onValidationError?(.password)
        }

        return isValid
    }
}

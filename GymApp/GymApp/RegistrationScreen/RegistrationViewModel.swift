//
//  RegistrationViewModel.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.05.2024.
//

import Foundation

class RegistrationViewModel {

    var onValidationError: ((ValidationError) -> Void)?
    var onValidationSuccess: ((ValidationError) -> Void)?
    var onRegistrationSuccess: (() -> Void)?
    var onRegistrationFailure: ((Error) -> Void)?

    private let firebaseAuthManager = FirebaseAuthManager.shared

    func registerUser(_ name: String?, _ email: String?, _ password: String?) {
        guard validate(name: name, email: email, password: password) else {
            return
        }

        guard let name = name, let email = email, let password = password else {
            return
        }

        Task {
            do {
                _ = try await firebaseAuthManager.registerUser(email: email, password: password, username: name)
                onRegistrationSuccess?()
            } catch {
                onRegistrationFailure?(error)
            }
        }
    }

    func validate(name: String?, email: String?, password: String?) -> Bool {
        var isValid = true

        if let name = name, name.count >= 2 {
            onValidationSuccess?(.name)
        } else {
            isValid = false
            onValidationError?(.name)
        }

        if let email = email, isValidEmail(email) {
            onValidationSuccess?(.email)
        } else {
            isValid = false
            onValidationError?(.email)
        }

        if let password = password, isValidPassword(password) {
            onValidationSuccess?(.password)
        } else {
            isValid = false
            onValidationError?(.password)
        }

        return isValid
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$&*]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
}

//
//  FirebaseStorageManager.swift
//  GymApp
//
//  Created by Азат Зиганшин on 02.06.2024.
//

import Foundation
import FirebaseStorage
import UIKit

actor FirebaseStorageManager {

    static let shared = FirebaseStorageManager()

    private init() {}

    func uploadUserAvatar(uid: String, imageData: Data) async throws -> URL {
        let storageRef = Storage.storage().reference().child("user_avatars/\(uid).jpg")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        return try await withCheckedThrowingContinuation { continuation in
            storageRef.putData(imageData, metadata: metadata) { _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else if let url = url {
                            continuation.resume(returning: url)
                        } else {
                            continuation.resume(
                                throwing: NSError(
                                    domain: "FirebaseStorageManager",
                                    code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "Unknown error"]
                                )
                            )
                        }
                    }
                }
            }
        }
    }

    func deleteUserAvatar(uid: String) async throws {
        let storageRef = Storage.storage().reference().child("user_avatars/\(uid).jpg")
        return try await withCheckedThrowingContinuation { continuation in
            storageRef.delete { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }

    func getUserAvatarURL(uid: String) async throws -> URL? {
        let storageRef = Storage.storage().reference().child("user_avatars/\(uid).jpg")
        return try await withCheckedThrowingContinuation { continuation in
            storageRef.downloadURL { url, error in
                if let error = error {
                    if (error as NSError).code == StorageErrorCode.objectNotFound.rawValue {
                        continuation.resume(returning: nil)
                    } else {
                        continuation.resume(throwing: error)
                    }
                } else if let url = url {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(
                        throwing: NSError(
                            domain: "FirebaseStorageManager",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Unknown error"]
                        )
                    )
                }
            }
        }
    }
}

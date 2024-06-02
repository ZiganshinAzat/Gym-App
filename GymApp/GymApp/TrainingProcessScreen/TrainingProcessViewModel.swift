//
//  TrainingProcessViewModel.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.04.2024.
//

import Foundation
import Combine

class TrainingProcessViewModel {

    private var cancellables: Set<AnyCancellable> = []
    private var timerPublisher: AnyPublisher<Date, Never>!
    private let firebaseAuthManager = FirebaseAuthManager.shared
    private let firebaseFirestoreManager = FirebaseFirestoreManager.shared
    private let cacheManager = CacheManager.shared

    @Published var timeElapsed: TimeInterval = 0

    init() {
        setupTimer()
    }

    private func setupTimer() {
        timerPublisher = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect().eraseToAnyPublisher()

        timerPublisher
            .scan(0) { count, _ in count + 1 }
            .map { TimeInterval($0) }
            .sink { [weak self] time in
                self?.timeElapsed = time
            }
            .store(in: &cancellables)
    }

    func resetTimer() {
        timeElapsed = 0
        cancellables.removeAll()
        setupTimer()
    }

    func getAuthenticatedUserId() async -> String? {
        return await firebaseAuthManager.getAuthenticatedUserId()
    }

    func saveTrainingHistory(trainingHistory: TrainingHistory) async {
        do {
            try await firebaseFirestoreManager.saveTrainingHistoryToDatabase(trainingHistory)

            cacheManager.addTrainingHistoryToCache(trainingHistory)
            print("Training history saved successfully.")
        } catch {
            print("Failed to save training history: \(error)")
        }
    }
}

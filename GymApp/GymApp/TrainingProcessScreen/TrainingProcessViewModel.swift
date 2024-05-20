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
}

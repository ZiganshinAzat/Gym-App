//
//  TrainingProcessViewController.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.04.2024.
//

import UIKit
import Combine

class TrainingProcessViewController: UIViewController {

    private let trainingProcessView = TrainingProcessView()
    private let trainingProcessViewModel: TrainingProcessViewModel
    private var exercisesDataSource: [Exercise] = [Exercise(title: "Жим лежа"), Exercise(title: "Становая тяга"), Exercise(title: "Присед")]
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: TrainingProcessViewModel) {
        self.trainingProcessViewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = trainingProcessView
        trainingProcessView.exercisesTableView.dataSource = self
        trainingProcessView.exercisesTableView.delegate = self
        trainingProcessView.finishTrainingButtonTapped = finishTrainingButtonAction
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    private func setupBindings() {
        trainingProcessViewModel.$timeElapsed
            .sink { [weak self] time in
                self?.updateTimerLabel(with: time)
            }
            .store(in: &cancellables)
    }

    private func updateTimerLabel(with time: TimeInterval) {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        self.trainingProcessView.stopwatchLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
}

extension TrainingProcessViewController: UITableViewDataSource, UITableViewDelegate {

    func finishTrainingButtonAction() {
        let alertController = UIAlertController(
            title: "Закончить тренировку",
            message: "Вы уверены, что хотите закончить эту тренировку?",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let finishAction = UIAlertAction(title: "Закончить", style: .default) { [weak self] _ in
            self?.completeTraining()
        }
        alertController.addAction(finishAction)

        present(alertController, animated: true, completion: nil)
    }

    private func completeTraining() {
        print("Training session finished")
    }

    func finishButtonTapped() {
        trainingProcessViewModel.resetTimer()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exercisesDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TrainingProcessTableViewCell.reuseIdentifier,
            for: indexPath) as? TrainingProcessTableViewCell else {
            return UITableViewCell()
        }

        cell.selectionStyle = .none
        cell.finishButtonTapped = self.finishButtonTapped

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var backgroundConfig = cell.defaultBackgroundConfiguration()
        backgroundConfig.backgroundColor = UIColor(red: 20/255, green: 24/255, blue: 41/255, alpha: 1.0)
        backgroundConfig.cornerRadius = 20
        backgroundConfig.backgroundInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        backgroundConfig.strokeColor = UIColor(red: 40/255, green: 42/255, blue: 60/255, alpha: 1.0)
        backgroundConfig.strokeWidth = 1.0

        cell.backgroundConfiguration = backgroundConfig
    }

    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 120
    //    }
}

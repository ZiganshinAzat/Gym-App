//
//  TrainingHistoryDetailView.swift
//  GymApp
//
//  Created by Азат Зиганшин on 28.05.2024.
//

import UIKit

class TrainingHistoryDetailView: UIView {

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 26, weight: .heavy)
        label.text = "Mock"
        return label
    }()

    lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "23.05"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    lazy var exercisesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrainingHistoryDetailView {
    func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(exercisesStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            exercisesStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            exercisesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            exercisesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            exercisesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func configure(with trainingHistory: TrainingHistory, trainingProgram: TrainingProgram) {
        titleLabel.text = trainingProgram.name

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 3 * 3600)
        dateLabel.text = dateFormatter.string(from: trainingHistory.date)

        exercisesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for exerciseHistory in trainingHistory.exerciseHistories {
            if let exercise = trainingProgram.exercises.first(where: { $0.id == exerciseHistory.exerciseID }) {
                let exerciseLabel = UILabel()
                exerciseLabel.textColor = .white
                exerciseLabel.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
                exerciseLabel.text = "\(exercise.name):"

                exercisesStackView.addArrangedSubview(exerciseLabel)

                for set in exerciseHistory.sets {
                    let setLabel = UILabel()
                    setLabel.textColor = .white
                    setLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
                    setLabel.text = "Подход \(set.index + 1): \(set.weight)кг x \(set.repetitions)"

                    exercisesStackView.addArrangedSubview(setLabel)
                }
            }
        }
    }

}

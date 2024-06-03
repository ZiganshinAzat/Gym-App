//
//  TrainingHistoryTableViewCell.swift
//  GymApp
//
//  Created by Азат Зиганшин on 23.05.2024.
//

import UIKit

class TrainingHistoryTableViewCell: UITableViewCell {

    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)

        return label
    }()

    lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        return label
    }()

    lazy var trainingIconImageView: UIImageView = {
        var imageView = RoundImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray

        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrainingHistoryTableViewCell {
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(trainingIconImageView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),

            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            trainingIconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            trainingIconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            trainingIconImageView.heightAnchor.constraint(equalToConstant: 50),
            trainingIconImageView.widthAnchor.constraint(equalTo: trainingIconImageView.heightAnchor)
        ])
    }

    func configureCell(with trainingHistory: TrainingHistory, trainingProgram: TrainingProgram) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 3 * 3600)

        let formattedDate = dateFormatter.string(from: trainingHistory.date)

        titleLabel.text = trainingProgram.name
        dateLabel.text = formattedDate
        trainingIconImageView.image = UIImage(named: trainingProgram.image)
    }
}

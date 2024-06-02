//
//  SetView.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.04.2024.
//

import UIKit

class SetView: UIView {

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)

        return label
    }()

    private lazy var finishButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        let action = UIAction { [weak self] _ in
            self?.finishButtonAction()
        }
        button.addAction(action, for: .touchUpInside)

        return button
    }()

    lazy var weightTextField: UITextField = {
        let textField = getTextField(with: "50")
        //        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()

    private lazy var kgLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "KG"

        return label
    }()

    lazy var repsTextField: UITextField = {
        let textField = getTextField(with: "8")
        //        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()

    private let repsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        label.text = "Reps."

        return label
    }()

    private var isCompleted: Bool = false
    var finishButtonTapped: (() -> Void)?
    var onInputChange: ((ExerciseSetInput) -> Void)?

    init() {
        super.init(frame: .zero)

        setupLayout()
        weightTextField.delegate = self
        repsTextField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SetView: UITextFieldDelegate {

    func finishButtonAction() {
        isCompleted.toggle()

        if self.isCompleted {
            self.setupCompletedSet()
        } else {
            self.setupNotCompletedSet()
        }
    }

    private func setupCompletedSet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.finishButton.setImage(UIImage(named: "checkCircle"), for: .normal)
            self.backgroundColor = UIColor(red: 0x38 / 255.0, green: 0x8e / 255.0, blue: 0x3d / 255.0, alpha: 1.0)
            let color = UIColor(red: 0x60 / 255.0, green: 0xa5 / 255.0, blue: 0x64 / 255.0, alpha: 1.0)
            self.weightTextField.backgroundColor = color
            self.repsTextField.backgroundColor = color
            self.layer.borderWidth = 0
            self.weightTextField.layer.borderWidth = 0
            self.repsTextField.layer.borderWidth = 0
            if self.weightTextField.text?.isEmpty ?? true {
                self.weightTextField.text = "50"
            }
            if self.repsTextField.text?.isEmpty ?? true {
                self.repsTextField.text = "8"
            }
            let input = ExerciseSetInput(weight: self.weightTextField.text ?? "", repetitions: self.repsTextField.text ?? "")
            self.onInputChange?(input)

            self.repsTextField.isUserInteractionEnabled = false
            self.weightTextField.isUserInteractionEnabled = false
        }) { finished in
            if finished {
                if let finishButtonTapped = self.finishButtonTapped {
                    finishButtonTapped()
                } else {
                    print("Не добавлено событие на кнопку")
                }
            } else {
                print("Анимация была прервана.")
            }
        }
    }

    private func setupNotCompletedSet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.finishButton.setImage(UIImage(named: "circle"), for: .normal)
            self.backgroundColor = UIColor(red: 20/255, green: 24/255, blue: 41/255, alpha: 1.0)
            let color = UIColor(red: 20/255, green: 24/255, blue: 41/255, alpha: 1.0)
            self.weightTextField.backgroundColor = color
            self.repsTextField.backgroundColor = color
            self.layer.borderWidth = 1
            self.weightTextField.layer.borderWidth = 1
            self.repsTextField.layer.borderWidth = 1
            self.weightTextField.text = ""
            self.repsTextField.text = ""
            let input = ExerciseSetInput(weight: self.weightTextField.text ?? "", repetitions: self.repsTextField.text ?? "")
            self.onInputChange?(input)

            self.repsTextField.isUserInteractionEnabled = true
            self.weightTextField.isUserInteractionEnabled = true
        })
    }

    private func setupLayout() {

        self.layer.borderColor = UIColor(red: 186/255.0, green: 187/255.0, blue: 190/255.0, alpha: 1.0).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true

        backgroundColor = UIColor(red: 20/255, green: 24/255, blue: 41/255, alpha: 1.0)

        addSubview(numberLabel)
        addSubview(finishButton)
        addSubview(weightTextField)
        addSubview(kgLabel)
        addSubview(repsTextField)
        addSubview(repsLabel)

        NSLayoutConstraint.activate([
            finishButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            finishButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            finishButton.heightAnchor.constraint(equalToConstant: 20),
            finishButton.widthAnchor.constraint(equalTo: finishButton.heightAnchor),

            numberLabel.centerYAnchor.constraint(equalTo: finishButton.centerYAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: finishButton.trailingAnchor, constant: 20),

            weightTextField.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 20),
            weightTextField.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            weightTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            weightTextField.widthAnchor.constraint(equalToConstant: 50),

            kgLabel.leadingAnchor.constraint(equalTo: weightTextField.trailingAnchor, constant: 20),
            kgLabel.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),

            repsTextField.leadingAnchor.constraint(equalTo: kgLabel.trailingAnchor, constant: 20),
            repsTextField.topAnchor.constraint(equalTo: weightTextField.topAnchor),
            repsTextField.bottomAnchor.constraint(equalTo: weightTextField.bottomAnchor),
            repsTextField.widthAnchor.constraint(equalTo: weightTextField.widthAnchor),

            repsLabel.leadingAnchor.constraint(equalTo: repsTextField.trailingAnchor, constant: 20),
            repsLabel.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor)
        ])
    }

    func setNumber(_ number: String) {
        numberLabel.text = number
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

    private func getTextField(with placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.textColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(red: 20/255, green: 24/255, blue: 41/255, alpha: 1.0)
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 186/255.0, green: 187/255.0, blue: 190/255.0, alpha: 1.0).cgColor
        textField.textColor = .white
        let placeholderText = placeholder
        let placeholderColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])

        return textField
    }
    //
    //    @objc private func textFieldDidChange(_ textField: UITextField) {
    //        let input = ExerciseSetInput(weight: weightTextField.text ?? "", repetitions: repsTextField.text ?? "")
    //        onInputChange?(input)
    //    }
}

//
//  CodeInputView.swift
//  GymApp
//
//  Created by Азат Зиганшин on 17.05.2024.
//

import UIKit

class NoCaretTextField: UITextField {
    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }
}

class CodeInputView: UIView, UITextFieldDelegate {

    private var textFields: [UITextField] = []
    private let numberOfFields: Int

    var code: String {
        return textFields.map { $0.text ?? "" }.joined()
    }

    init(numberOfFields: Int) {
        self.numberOfFields = numberOfFields
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        for _ in 0..<numberOfFields {
            let textField = NoCaretTextField()
            textField.borderStyle = .roundedRect
            textField.textAlignment = .center
            textField.font = UIFont.systemFont(ofSize: 24)
            textField.keyboardType = .numberPad
            textField.delegate = self
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            textFields.append(textField)
            addSubview(textField)
        }

        let stackView = UIStackView(arrangedSubviews: textFields)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        for textField in textFields {
            textField.widthAnchor.constraint(equalTo: textField.heightAnchor).isActive = true
        }
    }

    @objc private func textFieldDidChange(textField: UITextField) {
        guard let text = textField.text, text.count > 0 else { return }

        if textField == textFields.last {
            textField.resignFirstResponder()
        } else {
            if let nextTextField = textFields.first(where: { $0.text?.isEmpty == true }) {
                nextTextField.becomeFirstResponder()
            }
        }
    }

    func clearCode() {
        for textField in textFields {
            textField.text = ""
        }
        textFields.first?.becomeFirstResponder()
    }
}

//
//  EnterPersonInfoViewController.swift
//  Favourite Location
//
//  Created by Mohammad Bashtani on 9/14/22.
//

import Foundation
import UIKit


final class EnterPersonInfoViewController: UIViewController {
    private lazy var firstNameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "First name"
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.separator.cgColor
        return textfield
    }()
    
    private lazy var lastNameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Last name"
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.separator.cgColor
        return textfield
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    private func setupView() {
        self.view.backgroundColor = .systemBackground
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.addArrangedSubview(firstNameTextfield)
        stackView.addArrangedSubview(lastNameTextfield)
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 32, left: 16, bottom: 0, right: 16))
        [firstNameTextfield, lastNameTextfield].forEach { txtfield in
            txtfield.anchor(leading: stackView.leadingAnchor, trailing: stackView.trailingAnchor)
            txtfield.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
       setupButton()
    }
    
    private func setupButton() {
        self.view.addSubview(submitButton)
        submitButton.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.keyboardLayoutGuide.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 24, right: 16) )
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.layer.cornerRadius = 4
        submitButton.clipsToBounds = true
        submitButton.layer.borderColor = UIColor.opaqueSeparator.cgColor
        submitButton.layer.borderWidth = 0.8
        let constrinat = submitButton.widthAnchor.constraint(lessThanOrEqualToConstant: 200)
        constrinat.priority = .defaultHigh
        constrinat.isActive = true
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func submitButtonTapped() {
        
    }
}

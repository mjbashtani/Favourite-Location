//
//  ShowPersonLocationViewController.swift
//  Favourite Location
//
//  Created by Mohammad Bashtani on 9/13/22.
//

import Foundation
import UIKit

final class ShowPersonLocationViewController: UIViewController {
    let mapContainerView = UIView()
    let personListContainerView = UIView()
    var onAddButtonTap : (() -> Void)?
    private lazy var addButton: UIButton = {
        let button =  UIButton(type: .system)
        button.setImage(UIImage(named: "add")?.withRenderingMode(.alwaysTemplate).withTintColor(.systemBlue), for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.view.backgroundColor = .systemBackground
    }
    
    
    
    private func setupView() {
        self.view.addSubview(personListContainerView)
        personListContainerView.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        personListContainerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.view.addSubview(mapContainerView)
        mapContainerView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.personListContainerView.topAnchor, trailing: self.view.trailingAnchor)
        self.view.addSubview(addButton)
        addButton.anchor(bottom: self.personListContainerView.topAnchor, trailing: self.view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16), size: .init(width: 50, height: 50))
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
    }
    
    @objc
    private func addButtonTapped() {
        onAddButtonTap?()
    }
}

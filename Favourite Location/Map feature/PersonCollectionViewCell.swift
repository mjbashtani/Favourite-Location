//
//  PersonCollectionViewCell.swift
//  Favourite Location
//
//  Created by Mohammad Javad Bashtani on 6/20/1401 AP.
//

import Foundation
import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
     lazy var mainButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupView() {
        contentView.addSubview(mainButton)
        mainButton.fillSuperview()
        mainButton.setTitleColor(.label, for: .normal)
        mainButton.layer.cornerRadius = 4
        var buttonConfiguration = UIButton.Configuration.borderless()
        buttonConfiguration.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        mainButton.configuration = buttonConfiguration
        mainButton.layer.borderWidth = 0.7
        mainButton.layer.borderColor = UIColor.separator.cgColor
        mainButton.backgroundColor = .clear
        mainButton.clipsToBounds = true
    }
}

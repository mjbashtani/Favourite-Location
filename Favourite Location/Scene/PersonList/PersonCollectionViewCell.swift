//
//  PersonCollectionViewCell.swift
//  Favourite Location
//
//  Created by Mohammad Javad Bashtani on 6/20/1401 AP.
//

import Foundation
import UIKit

final class PersonCollectionViewCell: UICollectionViewCell {
     lazy var textLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupView() {
        let textContainer = UIView()
        contentView.addSubview(textContainer)
        textLabel.fillSuperview()
        textLabel.textColor = .label
        textContainer.layer.cornerRadius = 4
        textContainer.layer.borderWidth = 0.7
        textContainer.layer.borderColor = UIColor.separator.cgColor
        textContainer.backgroundColor = .clear
        textContainer.clipsToBounds = true
        textContainer.addSubview(textLabel)
        textContainer.fillSuperview()
        textLabel.anchor(top: textContainer.topAnchor, leading: textContainer.leadingAnchor, bottom: textContainer.bottomAnchor, trailing: textContainer.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    
    }
    
}

//
//  LabeledMarker.swift
//  Favourite Location
//
//  Created by Mohammad Bashtani on 9/13/22.
//

import Foundation
import GoogleMaps

class LabeledMarker: IdentifibleMarker {
    private var label: UILabel!
    
    init(labelText: String, ownerId: String) {
        super.init(ownerID: ownerId)
        
        let iconView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height:  100)))
        iconView.backgroundColor = .clear
        let imageView = UIImageView(image: .init(named: "customMarker"))
        iconView.addSubview(imageView)
        imageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: .init(width: 30, height: 45))
        imageView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: iconView.centerXAnchor).isActive = true
        imageView.image = .init(named: "customMarker")
        iconView.addSubview(imageView)
        label = UILabel()
        iconView.addSubview(label)
        label.anchor(top: imageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 2, left: 0, bottom: 0, right: 0))
        label.centerXAnchor.constraint(equalTo: iconView.centerXAnchor).isActive = true
        label.textAlignment = .center
        label.text = labelText
        label.font = .systemFont(ofSize: 15)
        label.sizeToFit()
        label.center.x = imageView.center.x
        self.iconView = iconView
    }
}

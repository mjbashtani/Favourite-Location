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

            let iconView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height:     80)))
            iconView.backgroundColor = .white

            label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width:     iconView.bounds.width, height: 40)))
            label.text = labelText
            iconView.addSubview(label)

            self.iconView = iconView
        }
}

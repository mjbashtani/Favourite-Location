//
//  UIView+Indicator.swift
//  Favourite Location
//
//  Created by Mohammad Bashtani on 9/13/22.
//

import UIKit

private var indicatorViewUnsafe: Int8 = 0
extension UIView {
    private var indicatorView: UIView? {
        get {objc_getAssociatedObject(self, &indicatorViewUnsafe) as? UIView }
        set {objc_setAssociatedObject(self, &indicatorViewUnsafe, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
    func showIndicator(style: UIActivityIndicatorView.Style? = nil, color: UIColor = .gray, backgroundColor: UIColor = .systemBackground) {
        guard indicatorView == nil else {return}
        var safeStyle: UIActivityIndicatorView.Style
        if #available(iOS 13, *) {
            safeStyle = style ?? .medium
        } else {
            safeStyle = style ?? .gray
        }
        let container = UIView()
        
        container.frame = self.frame
        container.backgroundColor = backgroundColor
        let indicatorView = UIActivityIndicatorView()
        indicatorView.frame.size = .init(width: 20, height: 20)
        indicatorView.color = color
        indicatorView.style = safeStyle
        indicatorView.center = container.center
        container.addSubview(indicatorView)
        self.addSubview(container)
        self.bringSubviewToFront(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: 0).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 0).isActive = true
        indicatorView.startAnimating()
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        container.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0).isActive = true
        container.layer.cornerRadius = self.layer.cornerRadius
        self.indicatorView = container
    }
    
    func hideIndicator() {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else {return}
            self.indicatorView?.removeFromSuperview()
            self.indicatorView = nil
        }
    }
}

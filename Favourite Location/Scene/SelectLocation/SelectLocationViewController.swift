//
//  SelectLocationViewController.swift
//  Favourite Location
//
//  Created by Mohammad Bashtani on 9/13/22.
//

import Foundation
import UIKit
import GoogleMaps
import CoreLocation

final class SelectLocationViewController: UIViewController {
    private let currentUserLocation: CLLocationCoordinate2D?
    static let defaultZoomLevel: Float = 17.0
    var locationSelected: ((CLLocationCoordinate2D) -> Void)?
    
    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.init()
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        return mapView
    }()
    
    private lazy var selectButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Select", for: .normal)
        button.backgroundColor = .systemBackground
        return button
    }()
    
    init(currentUserLocation: CLLocationCoordinate2D?) {
        self.currentUserLocation = currentUserLocation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    private func setupView() {
        self.view.addSubview(mapView)
        addLocationIndicator()
        currentUserLocation.map { location in
            setCameraTo(location: location)
        }
        setupButton()
    }
    
    private func addLocationIndicator() {
        let imageView = UIImageView(image: UIImage(named: "customMarker"))
        self.view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -45).isActive = true
        imageView.anchor(size: .init(width: 60, height: 90))
    }
    
    private func setupButton() {
        self.view.addSubview(selectButton)
        selectButton.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 24, right: 16) )
        selectButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        selectButton.layer.cornerRadius = 4
        selectButton.clipsToBounds = true
        selectButton.layer.borderColor = UIColor.opaqueSeparator.cgColor
        selectButton.layer.borderWidth = 0.8
        let constrinat = selectButton.widthAnchor.constraint(lessThanOrEqualToConstant: 200)
        constrinat.priority = .defaultHigh
        constrinat.isActive = true
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
    }
    
    private func setCameraTo(location: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: (location.latitude), longitude: (location.longitude), zoom: Self.defaultZoomLevel)
        self.mapView.animate(to: camera)
    }
    
    @objc
    private func selectButtonTapped() {
        let coordiante =  mapView.projection.coordinate(for: self.view.center)
        locationSelected?(coordiante)
    }
}

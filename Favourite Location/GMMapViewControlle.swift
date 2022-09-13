//
//  ViewController.swift
//  Favourite Location
//
//  Created by Mohammad Javad Bashtani on 6/20/1401 AP.
//

import UIKit
import GoogleMaps

class GMMapViewControlle: UIViewController {
    var currentUserLocation: CLLocationCoordinate2D? {
        didSet {
            guard let location = currentUserLocation else {
                return
            }
            let camera = GMSCameraPosition.camera(withLatitude: (location.latitude), longitude: (location.longitude), zoom: 17.0)
            self.mapView.animate(to: camera)
        }
    }
    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    private func setupView() {
        self.view.addSubview(mapView)
    }
    
    
}


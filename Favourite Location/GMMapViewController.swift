//
//  ViewController.swift
//  Favourite Location
//
//  Created by Mohammad Javad Bashtani on 6/20/1401 AP.
//

import UIKit
import GoogleMaps


final class GMMapViewController: UIViewController {
    private let markerController: MarkerController
    private var markers: [Weak<IdentifibleMarker>] = []
    static let defaultZoomLevel: Float = 17.0
    
    var currentUserLocation: CLLocationCoordinate2D? {
        didSet {
            guard let location = currentUserLocation else {
                return
            }
            let camera = GMSCameraPosition.camera(withLatitude: (location.latitude), longitude: (location.longitude), zoom: Self.defaultZoomLevel)
            self.mapView.animate(to: camera)
        }
    }
    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.init()
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        return mapView
    }()
    
    init(markerController: MarkerController) {
        self.markerController = markerController
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
    }
    
    
}

extension GMMapViewController: MapView {
    func showMarker(_ viewModel: MarkerViewModel) {
        let marker = LabeledMarker(labelText: viewModel.title, ownerId: viewModel.id)
        markers.append(.init(value: marker))
        marker.title = viewModel.title
        marker.position = CLLocationCoordinate2D(latitude: viewModel.latidude, longitude: viewModel.longitude)
        marker.map = mapView
        updateBounds()
        
        
    }
    
    func deleteMarker(_ viewModel: DeleteMarkerViewModel) {
        let filtredMarkers =  markers.filter { weakMarker in
            weakMarker.value?.ownerID == viewModel.id
        }.map(\.value)
        filtredMarkers.forEach { marker in
            marker?.map = nil
        }
        updateBounds()
        
    }
    
    func updateBounds() {
        var bounds = GMSCoordinateBounds()
        DispatchQueue.main.async { [self] in
            markers.map(\.value?.position).compactMap {$0}.forEach { loc in
                bounds =  bounds.includingCoordinate(loc)
            }
            let update = GMSCameraUpdate.fit(bounds, withPadding: 30)
            mapView.animate(with: update)
        }
        

    }
    
}



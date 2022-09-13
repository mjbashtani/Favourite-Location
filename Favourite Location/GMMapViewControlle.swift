//
//  ViewController.swift
//  Favourite Location
//
//  Created by Mohammad Javad Bashtani on 6/20/1401 AP.
//

import UIKit
import GoogleMaps

struct MarkerViewModel {
    let id: String
    let latidude: Double
    let longitude: Double
}

struct DeleteMarkerViewModel {
    let id: String
}
protocol MapView: AnyObject {
    func showMarker(_ viewModel: MarkerViewModel)
    func deleteMarker(_ viewModel: DeleteMarkerViewModel )
}

class MarkerController {
    weak var mapView: MapView?
    
    func addMarker(with location: CLLocationCoordinate2D, id: String) {
        let vm = MarkerViewModel(id: id, latidude: location.latitude, longitude: location.longitude)
        mapView?.showMarker(vm)
    }
    
    func deleteMarker(with id: String) {
        let vm = DeleteMarkerViewModel(id: id)
        mapView?.deleteMarker(vm)
    }
}

class GMMapViewControlle: UIViewController {
    private let markerController: MarkerController
    private var markers: [Weak<IdentifibleMarker>] = []
    
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

extension GMMapViewControlle: MapView {
    func showMarker(_ viewModel: MarkerViewModel) {
        let marker = IdentifibleMarker(ownerID: viewModel.id)
        markers.append(.init(value: marker))
        marker.position = CLLocationCoordinate2D(latitude: viewModel.latidude, longitude: viewModel.longitude)
        marker.map = mapView

    }
    
    func deleteMarker(_ viewModel: DeleteMarkerViewModel) {
      let filtredMarkers =  markers.filter { weakMarker in
            weakMarker.value?.ownerID == viewModel.id
      }.map(\.value)
        filtredMarkers.forEach { marker in
            marker?.map = nil
        }
    }
}

class IdentifibleMarker: GMSMarker {
    let ownerID: String
    
    init(ownerID: String) {
        self.ownerID = ownerID
        super.init()
    }
}

class Weak<T: AnyObject> {
  weak var value : T?
  init (value: T) {
    self.value = value
  }
}

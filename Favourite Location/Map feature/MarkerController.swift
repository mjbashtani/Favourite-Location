//
//  MarkerController.swift
//  Favourite Location
//
//  Created by Mohammad Bashtani on 9/13/22.
//

import Foundation
import CoreLocation

class MarkerController {
    weak var mapView: MapView?
    var currentLocation: CLLocationCoordinate2D?
    
    func addMarker(with location: Location, id: String, title: String) {
        let title = currentLocation.map { cLocation in
            formatDistance(from: cLocation, to: .init(latitude: location.latitude, longitude: location.longitude))
        }
        let vm = MarkerViewModel(id: id, latidude: location.latitude, longitude: location.longitude, infoText: title ?? "")
        mapView?.showMarker(vm)
    }
    
    func deleteMarker(with id: String) {
        let vm = DeleteMarkerViewModel(id: id)
        mapView?.deleteMarker(vm)
        
    }
    
    private func formatDistance(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) -> String {
        let distance = CLLocation(latitude: origin.latitude, longitude: origin.longitude).distance(from: .init(latitude: destination.latitude, longitude: destination.longitude))
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .long
        formatter.unitOptions = .providedUnit
        let measurement = Measurement(value: distance/1000, unit: UnitLength.kilometers)
        return formatter.string(from: measurement)
    }
}

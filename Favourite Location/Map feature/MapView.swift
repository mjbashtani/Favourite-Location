//
//  MapView.swift
//  Favourite Location
//
//  Created by Mohammad Bashtani on 9/13/22.
//

import Foundation

struct MarkerViewModel {
    let id: String
    let latidude: Double
    let longitude: Double
    let infoText: String
   
}

struct DeleteMarkerViewModel {
    let id: String
}

protocol MapView: AnyObject {
    func showMarker(_ viewModel: MarkerViewModel)
    func deleteMarker(_ viewModel: DeleteMarkerViewModel )
}

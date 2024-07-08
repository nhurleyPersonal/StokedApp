//
//  CustomMapView.swift
//  Stoked
//
//  Created by Noah Hurley on 7/7/24.
//

import MapKit
import SwiftUI

struct CustomMapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D
    var span: MKCoordinateSpan

    func makeUIView(context _: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .satellite
        mapView.isUserInteractionEnabled = false
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context _: Context) {
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
    }
}



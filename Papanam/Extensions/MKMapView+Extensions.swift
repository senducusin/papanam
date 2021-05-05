//
//  MKMapView+Extensions.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/5/21.
//

import MapKit
 // Working in-progress
extension MKMapView {
    func zoomToFit(annotations:[MKAnnotation]){
        var zoomRect = MKMapRect.null
        
        let annotations = annotations.filter({ !$0.isKind(of: DriverAnnotation.self) })
        
        annotations.forEach { annotation in
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
            zoomRect = zoomRect.union(pointRect)
        }
        
        let insets = UIEdgeInsets(top: 100, left: 100, bottom: 250, right: 100)
        setVisibleMapRect(zoomRect,edgePadding: insets, animated: true)
    }
}

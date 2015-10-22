//
//  MapViewController.swift
//  Airports
//
//  Created by Kevin van der Vleuten on 24/09/15.
//  Copyright © 2015 Kevin van der Vleuten. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    var airportName: String?
    var anchorIndex: Int?
    
    @IBOutlet weak var mapSegmentControl: UISegmentedControl!
    @IBOutlet weak var airportsMap: MKMapView!
    
    @IBOutlet weak var label1: UILabel!
    
    //var initialLocation: CLLocationCoordinate2D!
    //let schipholLocation = CLLocationCoordinate2D(latitude: 52.3086013794, longitude: 4.76388978958)
    
    var departureLocation: CLLocationCoordinate2D!
    var destinationLocation: CLLocationCoordinate2D!
    
    var airplaneAnnotation: CustomPointAnnotation = CustomPointAnnotation()
    var airplaneAnnotationPosition: NSInteger = 0
    var airplaneAnnotationRotation: Double!
    
    var geoLine: MKGeodesicPolyline!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        airportsMap.delegate = self // if you forget this, no drawings...
        label1.text = airportName
        
        departureLocation = (airportDeparture?.location)!
        destinationLocation = (airportDestination?.location)!
        
        centerMapOnLocation(departureLocation)
        
        geoLine = createRoute()
        self.airportsMap.addOverlay(geoLine)
        self.airportsMap.insertOverlay(geoLine, aboveOverlay: airportsMap.overlays.last!)
        
        airplaneAnnotation.title = "Airplane"
        airplaneAnnotation.coordinate = departureLocation
        airplaneAnnotation.imageName = "airplane3"
        self.airportsMap.addAnnotation(airplaneAnnotation)
        
        drawAnnotation((airportDeparture?.name)!, location: departureLocation, type: "airport")
        drawAnnotation((airportDestination?.name)!, location: destinationLocation, type: "airport")
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "updateAirplane", userInfo: nil, repeats: true)
        
        print("drawing complete")
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let PinIdentifier = "airport"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(PinIdentifier)
        if (anView == nil) {
            anView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: PinIdentifier)
        }
        if (annotation is CustomPointAnnotation) {
            let imageAnnotation = annotation as! CustomPointAnnotation
            anView?.image = UIImage(named: imageAnnotation.imageName)
        }
        
        return anView!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let loc = CLLocation(latitude: location.latitude, longitude: location.longitude);
        
        let regionRadius: CLLocationDirection = 6000000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(loc.coordinate,regionRadius, regionRadius)
        self.airportsMap.setRegion(coordinateRegion, animated: false)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.lineWidth = 3
            lineView.strokeColor = UIColor.redColor()
            return lineView
        }
        return nil
    }
    
    func createRoute() -> MKGeodesicPolyline {
        //let myPath = NSBundle.mainBundle().pathForResource("Flightplan", ofType: "plist")

        var locations: [CLLocationCoordinate2D] = [departureLocation, destinationLocation]
        
        //let myPolyLine = MKPolyline(coordinates: &locations, count: 2)
        let myGeodesicLine = MKGeodesicPolyline(coordinates: &locations, count: 2)
        
        let loc1: CLLocation = CLLocation(latitude: departureLocation.latitude, longitude: departureLocation.longitude)
        let loc2: CLLocation = CLLocation(latitude: destinationLocation.latitude, longitude: destinationLocation.longitude)
        
        let distance: CLLocationDistance = loc1.distanceFromLocation(loc2)
        
        label1.text = String(format: "Distance: %0.2f KM", distance/1000)
        
        return myGeodesicLine
    }
    
    @IBAction func test(sender: AnyObject) {
        switch (mapSegmentControl.selectedSegmentIndex) {
        case 0:
            airportsMap.mapType = MKMapType.Standard
        case 1:
            airportsMap.mapType = MKMapType.Hybrid
        case 2:
            airportsMap.mapType = MKMapType.Satellite
        default:
            airportsMap.mapType = MKMapType.Standard
        }
    }
    
    func drawAnnotation(name: String, location: CLLocationCoordinate2D, type: String) {
        let annotation = CustomPointAnnotation()
        annotation.title = name
        annotation.coordinate = location
        annotation.imageName = type
        
        self.airportsMap.addAnnotation(annotation)
    }
    
    func updateAirplane() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
                let step: NSInteger = 3
                
                if self.airplaneAnnotationPosition + step >= self.geoLine.pointCount {
                    return
                }
                let prevMapPoint: MKMapPoint = self.geoLine.points()[self.airplaneAnnotationPosition]
                self.airplaneAnnotationPosition += step
                let nextMapPoint: MKMapPoint = self.geoLine.points()[self.airplaneAnnotationPosition]
                
                self.airplaneAnnotationRotation = self.RotationBetweenPoints(prevMapPoint, destinationPoint: nextMapPoint)
                self.airplaneAnnotation.coordinate = MKCoordinateForMapPoint(nextMapPoint)
                
                let rotation: CGFloat = CGFloat(self.DegreesToRadians(self.airplaneAnnotationRotation))
                
                self.airportsMap.viewForAnnotation(self.airplaneAnnotation)?.transform = CGAffineTransformRotate(self.airportsMap.transform, rotation)
            }
        }
    }
    
    func RotationBetweenPoints(sourcePoint:MKMapPoint, destinationPoint:MKMapPoint) -> CLLocationDirection{
        let x: Double = destinationPoint.x - sourcePoint.x;
        let y: Double = destinationPoint.y - sourcePoint.y;
    
        return fmod(RadiansToDegrees(atan2(y, x)), 360.0) + 90.0;
    }
    
    func RadiansToDegrees(radians: Double) -> Double {
        return (radians * 180.0) / M_PI
    }
    
    func DegreesToRadians(degrees: Double) -> Double {
        return (degrees * M_PI) / 180.0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue to \(segue.identifier)")
        
        if segue.identifier == "segueToTable" {
            if let destination = segue.destinationViewController as? AirportTableViewController {
                destination.anchorIndex = self.anchorIndex! //  airportName = airports[(self.tableView.indexPathForSelectedRow!.row)].name
            }
        }
    }
    
    class CustomPointAnnotation: MKPointAnnotation {
        var imageName: String!
    }
}

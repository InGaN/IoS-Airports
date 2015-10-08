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
    var initialLocation: CLLocationCoordinate2D!
    let schipholLocation = CLLocationCoordinate2D(latitude: 52.3086013794, longitude: 4.76388978958)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        airportsMap.delegate = self // if you forget this, no drawings...
        label1.text = airportName
        
        centerMapOnLocation(initialLocation)
        createRoute()
        drawAnnotation(airportName!, location: initialLocation, type: "airport")
        drawAnnotation("Schiphol", location: schipholLocation, type: "airport")
        
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
        
        let regionRadius: CLLocationDirection = 8000000
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
    
    func createRoute() {
        //let myPath = NSBundle.mainBundle().pathForResource("Flightplan", ofType: "plist")
        let otherLocation = initialLocation
        var locations: [CLLocationCoordinate2D] = [schipholLocation, otherLocation]
        
        //let myPolyLine = MKPolyline(coordinates: &locations, count: 2)
        let myGeodesicLine = MKGeodesicPolyline(coordinates: &locations, count: 2)
        
        let loc1: CLLocation = CLLocation(latitude: schipholLocation.latitude, longitude: schipholLocation.longitude)
        let loc2: CLLocation = CLLocation(latitude: otherLocation.latitude, longitude: otherLocation.longitude)
        
        let distance: CLLocationDistance = loc1.distanceFromLocation(loc2)
        
        label1.text = String(format: "Distance: %0.2f KM", distance/1000)
        
        self.airportsMap.addOverlay(myGeodesicLine)
        self.airportsMap.insertOverlay(myGeodesicLine, aboveOverlay: airportsMap.overlays.last!)
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
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

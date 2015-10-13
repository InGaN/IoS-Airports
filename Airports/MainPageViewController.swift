//
//  MainPageViewController.swift
//  Airports
//
//  Created by Kevin van der Vleuten on 13/10/15.
//  Copyright © 2015 Kevin van der Vleuten. All rights reserved.
//

import UIKit
var airportDestination: Airport?
var airportDeparture: Airport?

class MainPageViewController: UIViewController {
    
    var airportNameDestination: String?
    var airportNameDeparture: String?    
    
    @IBOutlet weak var labelDestination: UILabel!
    @IBOutlet weak var labelDeparture: UILabel!
    @IBOutlet weak var buttonFly: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if(airportDeparture != nil) {
            labelDeparture.text = airportDeparture?.name
        }
        else {
            labelDeparture.text = "Select Departure Airport"
        }
        
        if(airportDestination != nil) {
            labelDestination.text = airportDestination?.name
        }
        else {
            labelDestination.text = "Select Destination Airport"
        }
        
        buttonFly.enabled = (airportDeparture != nil && airportDestination != nil)
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue to \(segue.identifier)")
        
        if segue.identifier == "segueDepMainToTable" {
            if let destination = segue.destinationViewController as? AirportTableViewController {
                destination.DepDes = false;
            }
        }
        else if segue.identifier == "segueDesMainToTable" {
            if let destination = segue.destinationViewController as? AirportTableViewController {
                destination.DepDes = true;
            }
        }
        else if segue.identifier == "segueDepMainToCountry" {
            if let destination = segue.destinationViewController as? CountryCollectionViewController {
                destination.DepDes = false;
            }
        }
        else if segue.identifier == "segueDesMainToCountry" {
            if let destination = segue.destinationViewController as? CountryCollectionViewController {
                destination.DepDes = true;
            }
        }
        else if segue.identifier == "segueMainToMap" {
            if let destination = segue.destinationViewController as? MapViewController {
                
            }
        }
    }
}

//
//  AirportTableViewController.swift
//  Airports
//
//  Created by Kevin van der Vleuten on 21/09/15.
//  Copyright © 2015 Kevin van der Vleuten. All rights reserved.
//


import UIKit
import MapKit


class Airport: NSObject {
    
    var icao : String?
    var name : String?
    var location : CLLocationCoordinate2D?
    var elevation : Double?
    var iso_country : String?
    var municipality : String?
    
}

class AirportTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var airports = [Airport]()
    var filteredAirports = [Airport]()
    
    @IBOutlet var myTableView: UITableView!
    var anchorIndex: Int = 0
    var countryCode: String?
    var searching: Bool = false // incredibly blunt way to do this...
    var DepDes: Bool = false // 0 = Depart, 1 = Destination
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.blackColor()
        let adbh = AirportDatabaseHelper.sharedInstance
        if((countryCode?.isEmpty) != nil) {
            self.airports = adbh.getInfoWithISOCountry(countryCode!)!
        }
        else {
            self.airports = adbh.getAllAirports()!
        }
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    func filterContentForSearchText(searchText: String) {
        self.filteredAirports = self.airports.filter({
            (airport: Airport) -> Bool in
            //let categoryMatch = (scope == "All") || (airport.name == scope)
            let stringMatch = airport.name?.rangeOfString(searchText)
            return (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text!)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            searching = true;
            return self.filteredAirports.count
        }
        else {
            searching = false;
            return airports.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("tableCellOne", forIndexPath: indexPath)
        
        let row = indexPath.row
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            cell.textLabel?.text = filteredAirports[row].icao! + " - " + filteredAirports[row].name!
            cell.detailTextLabel?.text = filteredAirports[row].municipality
        }
        else {
            cell.textLabel?.text = airports[row].icao! + " - " + airports[row].name!
            cell.detailTextLabel?.text = airports[row].municipality
        }
        
        //tableView.scrollToRowAtIndexPath(NSIndexPath.init(index: anchorIndex), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue to \(segue.identifier)")
        
        let searchIndex: Int
        if searching {
            searchIndex = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow!.row
        }
        else {
            // not using search function
            searchIndex = self.tableView.indexPathForSelectedRow!.row
        }
        // obsolete
        if segue.identifier == "segueToMap" {
            print(NSString(format:"selected index: %d ", searchIndex))
            if let destination = segue.destinationViewController as? MapViewController {
                destination.airportName = airports[searchIndex].name
                //destination.initialLocation = airports[searchIndex].location;
                destination.anchorIndex = searchIndex
            }
        }
        
        else if segue.identifier == "segueTableToMain" {
            print(NSString(format:"selected index: %d DepDes: %d", searchIndex, DepDes))
            if DepDes { // Destination
                if let destination = segue.destinationViewController as? MainPageViewController {
                    if searching {
                        airportDestination = filteredAirports[searchIndex]
                    }
                    else {
                        airportDestination = airports[searchIndex]
                    }
                }
            }
            else { // Departure
                if let destination = segue.destinationViewController as? MainPageViewController {
                    if searching {
                        airportDeparture = filteredAirports[searchIndex]
                    }
                    else {
                        airportDeparture = airports[searchIndex]
                    }
                }
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
}

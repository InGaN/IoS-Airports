//
//  CountryCollectionViewController.swift
//  Airports
//
//  Created by Kevin van der Vleuten on 29/09/15.
//  Copyright © 2015 Kevin van der Vleuten. All rights reserved.
//

import UIKit

class CountryCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "CountryCell"
    private let sectionInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
    var cellColor = true
    var countryCodes = [String]();
    
    var countries: [[String]] = [
        ["AE", "AF", "AM", "PW"], // Asia
        ["GB", "AD", "ES", "AL"], // Europe
        ["SS", "MG", "TD", "MZ"], // Africa
        ["MH", "MP", "PG", "SB"], // Oceania
        ["US", "PR", "MX"], // N America
        ["CO"] // S America
    ]
    // AQ - antarctica
    var continents: [String] = [
        "Asia", "Europe", "Africa", "Oceania", "North America", "South America"
    ]
    
    var xIndex = 0;
    var yIndex = 0;
    
    var DepDes: Bool = false // 0 = Depart, 1 = Destination
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 6
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countries[section].count //243
        // might want to help people out by putting this info online
    }
    
    
    override func viewDidLoad() {
        let adbh = AirportDatabaseHelper.sharedInstance
        self.countryCodes = adbh.getISOCountryCodes()!
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CountryCell", forIndexPath: indexPath) as! CountryCollectionViewCell
        cell.backgroundColor = cellColor ? UIColor.redColor() : UIColor.blueColor()
        cellColor = !cellColor
    
        let index = indexPath.row
        yIndex = indexPath.section
        xIndex = index
        
        
        cell.flagImage.image = validCountryFlag(countries[yIndex][index])
        cell.countryName.text = countries[yIndex][index]
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CountryCodeHeaderView", forIndexPath: indexPath) as! CountryCodeHeaderView
            let index = indexPath.section
            
            headerView.titleLabel.text = continents[index]
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }

    
    func validCountryFlag(code: String) -> UIImage {
        if (UIImage(named: code) == nil) {
            return UIImage(named: "unknown_flag")!
        }
        else {
            return UIImage(named: code)!
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue to \(segue.identifier)")
        
        if segue.identifier == "segueFlagsToTable" {
            if let destination = segue.destinationViewController as? AirportTableViewController {
                //self.tableView.indexPathForSelectedRow!.row
                let selectedCell = ((sender as? CountryCollectionViewCell)!)
                destination.countryCode = selectedCell.countryName.text
                destination.DepDes = self.DepDes
            }
        }
    }
}

//
//  AirportDatabaseHelper.swift
//  Airports
//
//  Created by Diederich Kroeske on 9/13/15.
//  Copyright (c) 2015 Diederich Kroeske. All rights reserved.
//

// How to get SQLite to work
// Project name > General tab > Linked Frameworks and Libraries, add: libsqlite3.0.tbd & libsqlite3.tbd
// Add the headerfile which imports SQLite to the project
// Add the same file with path, ex Airports/Airport-Bridging-Header.h to debug and release
// That should be enough.

import UIKit
import MapKit



class AirportDatabaseHelper: NSObject {
    
    // Make the class singleton
    static let sharedInstance = AirportDatabaseHelper()
    
    // Database pointer
    var db : COpaquePointer = nil
    
    override init() {
        
        let path = NSBundle.mainBundle().pathForResource("airports", ofType: "sqlite"); // dont use ( and ) chars
        print(path)
        if sqlite3_open(path!, &db) != SQLITE_OK {
            print("error opening airports database")
        }
    }
    
    
    func getISOCountryCodes() -> [String]? {
        var codes = [String]()
        
        let query = "SELECT DISTINCT iso_country FROM airports";
        var statement : COpaquePointer = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String.fromCString(sqlite3_errmsg(db))
            print("error query: \(errmsg)")
            return .None
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            codes.append(String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 0)))!)
        }
        
        return codes
    }
    
    func getISOCountryCodesAmount() -> Int {
        
        let query = "SELECT COUNT(DISTINCT iso_country) FROM airports";
        var statement : COpaquePointer = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String.fromCString(sqlite3_errmsg(db))
            print("error query: \(errmsg)")
        }
        let vx = (Int)(String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 0)))!)!
        // doesnt work!
        return 100
    }
    

    func getInfoWithISOCountry(countryCode : String) -> [Airport]? {
        
        var airports = [Airport]()
        
        let query = "SELECT * FROM airports WHERE iso_country = \"\(countryCode.uppercaseString)\""
        
        // Prepare query and execute
        var statement : COpaquePointer = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String.fromCString(sqlite3_errmsg(db))
            print("error query: \(errmsg)")
            return .None
        }
        
        // Convert results to objects
        while sqlite3_step(statement) == SQLITE_ROW {
            let airport = Airport();
            
            // ICAO code and naming
            airport.icao = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 0)));
            airport.name = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 1)));
            
            // GPS coordinates
            let longitude : CLLocationDegrees = sqlite3_value_double(sqlite3_column_value(statement, 2))
            let latitude : CLLocationDegrees = sqlite3_value_double(sqlite3_column_value(statement, 3))
            airport.location = CLLocationCoordinate2DMake(latitude, longitude)
            airport.elevation = sqlite3_value_double(sqlite3_column_value(statement, 4))
            
            // Country and city
            airport.iso_country = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 5)));
            airport.municipality = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 6)));
            
            // Add to result
            airports.append(airport)
        }
        return airports
    }
    
    func getAllAirports() -> [Airport]? {
        
        var airports = [Airport]()
        
        let query = "SELECT * FROM airports"

        var statement : COpaquePointer = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String.fromCString(sqlite3_errmsg(db))
            print("error query: \(errmsg)")
            return .None
        }
        
        // Convert results to objects
        while sqlite3_step(statement) == SQLITE_ROW {
            let airport = Airport();
            
            // ICAO code and naming
            airport.icao = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 0)));
            airport.name = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 1)));
            
            // GPS coordinates
            let longitude : CLLocationDegrees = sqlite3_value_double(sqlite3_column_value(statement, 2))
            let latitude : CLLocationDegrees = sqlite3_value_double(sqlite3_column_value(statement, 3))
            airport.location = CLLocationCoordinate2DMake(latitude, longitude)
            airport.elevation = sqlite3_value_double(sqlite3_column_value(statement, 4))
            
            // Country and city
            airport.iso_country = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 5)));
            airport.municipality = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 6)));
            
            // Add to result
            airports.append(airport)
        }
        return airports
    }
}

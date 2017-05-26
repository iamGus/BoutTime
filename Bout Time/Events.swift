//
//  Events.swift
//  Bout Time
//
//  Created by Angus Muller on 26/05/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation
import UIKit

protocol EachEvent { // Making sure year data is inlcuded in event, though each event only has one conncted value (year), this structure has been chosen as it will make it easy to add more fields (e.g. url) at a later stafe if desired.
    var year: Int { get }
}

struct Event: EachEvent {
    let year: Int
}

// error states for collecting data
enum DataError: Error {
    case invalidResource
    case conversionFailure
    case invalidSelection
}

// Converts event data from a plist file and puts (converts) data into a dictionary
class Plistconverter {
    static func dictionary(fromFile name: String, ofType type: String) throws -> [String: AnyObject] { // NOTE wonder about changed to [String: Int]
        guard let path = Bundle.main.path(forResource: name, ofType: type) else { // checks the file path is valid
            throw DataError.invalidResource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else { // Gets data and converts is into dictionary
            throw DataError.conversionFailure
        }
        
        return dictionary
    }
}

//
class EventDataUnarchiver {
    static func eventData(fromDictionary dictionary: [String: AnyObject]) throws -> [String: EachEvent] {
        
        var eventData: [String: EachEvent] = [:] //NOTE dont think data is best word here to describe it
        
        for (key, value) in dictionary {
            if let itemDictionary = value as? [String: Any], let year = itemDictionary["year"] as? Int {
                let year = Event(year: year)
                
                // I am missing out the invalidselction as I think this is covered already in importing key as String
                
                
            eventData.updateValue(year, forKey: key)
            
            }
        }
        
        
       return eventData
    }
}






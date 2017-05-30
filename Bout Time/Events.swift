//
//  Events.swift
//  Bout Time
//
//  Created by Angus Muller on 26/05/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation
import UIKit

protocol EachEventContent { // Making sure year data is inlcuded in event, though each event only has one conncted value (year), this structure has been chosen as it will make it easy to add more fields (e.g. url) at a later stafe if desired.
    var year: Int { get }
}

protocol EachEventKey {
    var name: String { get }
}

struct EventContent: EachEventContent {
    let year: Int
}

// error states for collecting data
enum DataError: Error {
    case invalidResource
    case conversionFailure
    case invalidData
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
    static func eventData(fromDictionary dictionary: [String: AnyObject]) throws -> [String: EachEventContent] {
        
        var eventData: [String: EachEventContent] = [:] //NOTE dont think data is best word here to describe it
        
        for (key, value) in dictionary {
            if let itemDictionary = value as? [String: Any], let year = itemDictionary["year"] as? Int {
                let year = EventContent(year: year)
                eventData.updateValue(year, forKey: key)
            
                } else {
            
                throw DataError.invalidData
                }
        }
        
       return eventData
    }
}


class Rounds {
    
    func fourRandomNumbers(maxQuestion max: Int) -> [Int] {
        var result: [Int] = [] // Array to return four random numbers
        var nums = Array(0..<max) // Store numbers and remove when used, to stop number being repeated in reults array
        
        for _ in 1...4 { // repeat 4 times
            
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(nums.count)))
            
            // random number
            result.append(nums[arrayKey])
            
            // make sure the number isnt repeated
            nums.remove(at: arrayKey)
        }
        return result
    }
    /*
    
    func nextRound(dictionary: [String: EachEvent]) -> [String: EachEventContent] {
        var fourRandomQuestions: [String: EachEvent] = [:]
        var fourNumbers = fourRandomNumbers(maxQuestion: dictionary.count)
        for i in fourNumbers {
            
            fourRandomQuestions = (EachEvent)
        }
        
        return fourRandomQuestions
    }
 */
}




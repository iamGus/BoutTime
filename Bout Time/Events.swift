//
//  Events.swift
//  Bout Time
//
//  Created by Angus Muller on 26/05/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import Foundation
import UIKit

protocol EventContent { // Making sure year data is inlcuded in event, though each event only has one conncted value (year), this structure has been chosen as it will make it easy to add more fields (e.g. url) at a later stafe if desired.
    var event: String { get }
    var year: Int { get }
}

protocol EventRounds {
    var eventDictionary: [EventContent] {get set }
    
    init(eventDictionary: [EventContent])
    func fourRandomNumbers(maxQuestion max: Int) -> [Int]
    func nextRound() -> [EventContent]
    func checkRound(orderOfQuestions: [EventContent]) -> Bool
}

struct Event: EventContent {
    var event: String
    var year: Int
    
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
    static func eventData(fromDictionary dictionary: [String: AnyObject]) throws -> [EventContent] {
        
        var eventData: [EventContent] = [] //NOTE dont think data is best word here to describe it
        
        for (key, value) in dictionary {
            if let itemDictionary = value as? [String: Any], let year = itemDictionary["year"] as? Int {
                let content = Event(event: key, year: year)
                eventData.append(content)
            
                } else {
            
                throw DataError.invalidData
                }
        }
        
       return eventData
    }
}


class AllRounds: EventRounds {
    
    var eventDictionary: [EventContent]
    
    required init(eventDictionary: [EventContent]) {
        self.eventDictionary = eventDictionary
    }
    
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
    
    
    func nextRound() -> [EventContent] {
        var fourRandomQuestions: [EventContent] = []
        let fourNumbers = fourRandomNumbers(maxQuestion: eventDictionary.count)
        for i in fourNumbers {
            let eachEvent = eventDictionary[i]
            let content = Event(event: eachEvent.event, year: eachEvent.year)
            fourRandomQuestions.append(content)
        }
        return fourRandomQuestions
    }
    
    // Check if years in a round are in order and return true for correct or false for wrong order
    func checkRound(orderOfQuestions: [EventContent]) -> Bool {
        var checkYearOrder: [Int] = []
        var answer: Bool = true
        var i = 0
        // Get years from input and put just the year (not the event name) into own array
        for i in orderOfQuestions {
            checkYearOrder.append(i.year)
        }
        // Loop over the years in array checking if in order
        for _ in checkYearOrder {
            if checkYearOrder[i] >= checkYearOrder[i+1] {
                answer = false
                break
            } else if i < 2 {
                    i += 1
            } else {
            break
            }
        }
        return answer
    }
 
}




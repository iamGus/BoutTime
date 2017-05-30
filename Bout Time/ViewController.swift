//
//  ViewController.swift
//  Bout Time
//
//  Created by Angus Muller on 22/05/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //IBOulets
    @IBOutlet weak var eventLabel1: UILabel!
    @IBOutlet weak var eventLabel2: UILabel!
    @IBOutlet weak var eventLabel3: UILabel!
    @IBOutlet weak var eventLabel4: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    
    let dictionaryOfEvents: [String: EachEventContent] // NOTE this might change but currently set so can test what data import looks like
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try Plistconverter.dictionary(fromFile: "events", ofType: "plist")
            let inventory = try EventDataUnarchiver.eventData(fromDictionary: dictionary)
            self.dictionaryOfEvents = inventory
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //test to see data in dictionary - it works! - CHANGE this to be calling function below *func
        
        for (key, value) in dictionaryOfEvents {
            print("\(key) happend in \(value.year)\n")
        }
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup and display round
    
    //displayround func
//    func displayRound() {
//        let fourEvents = Rounds.nextRound
//    }
    
    
    // MARK: - Each Round
    
   
    

    @IBAction func box1DownArrow() {
    }

    @IBAction func box2UpArrow() {
    }
    
    @IBAction func box2DownArrow() {
    }
    
    @IBAction func box3UpArrow() {
    }
    
    @IBAction func box3DownArrow() {
    }
    
    @IBAction func box4UpArrow() {
    }
    
    @IBAction func shakeToCompleteButton() {
    }
    
    
    
    
}


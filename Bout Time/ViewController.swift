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
    
    
    // Propertoies to setup
    let dictionaryOfEvents: EventRounds
    var fourRandomEvents: [EventContent]
    let howManyRounds = 6
    var roundsCompleted = 0 // So game knows how many rounds it has already done
    var roundsCorrect = 0 // Counter to keep track of how many rounds correctly completed - for score
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try Plistconverter.dictionary(fromFile: "events", ofType: "plist")
            let inventory = try EventDataUnarchiver.eventData(fromDictionary: dictionary)
            self.dictionaryOfEvents = AllRounds(eventDictionary: inventory)
            self.fourRandomEvents = []
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayround()
        
        //test to see data in dictionary - it works! - CHANGE this to be calling function below *func
        
        let space = dictionaryOfEvents.eventDictionary[0]
        print(space.event)
        
        let random = dictionaryOfEvents.nextRound()
        print(random[0].event)
        
        
       // let key0 = dictionaryOfEvents.eventDictionary[0]
       // print(key0)
        //print(key0)
        
        //for event in dictionaryOfEvents.eventDictionary {
        //    print("\(event.event) in \(event.year)")
        //}
        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup and display round
    func displayround() {
        fourRandomEvents = dictionaryOfEvents.nextRound()
        eventLabel1.text = "\(fourRandomEvents[0].event)"
        eventLabel2.text = "\(fourRandomEvents[1].event)"
        eventLabel3.text = "\(fourRandomEvents[2].event)"
        eventLabel4.text = "\(fourRandomEvents[3].event)"
    }
    
    // End of round - check score and show correct or wrong button
    
    // If phone is shaked 
    // NOTE will need to put error in if shake when rounds ended.
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake {
            print("Shake")
            let answer = dictionaryOfEvents.checkRound(orderOfQuestions: fourRandomEvents)
            print(answer)
        }
    }
   
    @IBAction func box1DownArrow() {
       rearrangeRound(fromIndex: 0, toIndex: 1)
    }

    @IBAction func box2UpArrow() {
        rearrangeRound(fromIndex: 1, toIndex: 0)
    }
    
    @IBAction func box2DownArrow() {
        rearrangeRound(fromIndex: 1, toIndex: 2)
    }
    
    @IBAction func box3UpArrow() {
        rearrangeRound(fromIndex: 2, toIndex: 1)
    }
    
    @IBAction func box3DownArrow() {
        rearrangeRound(fromIndex: 2, toIndex: 3)
    }
    
    @IBAction func box4UpArrow() {
        rearrangeRound(fromIndex: 3, toIndex: 2)
    }
    
    @IBAction func shakeToCompleteButton() {
    }
    
    // Changes fourRandomEvent array order and updates buttons text fields
    func rearrangeRound(fromIndex: Int, toIndex: Int) {
        swap(&fourRandomEvents[fromIndex], &fourRandomEvents[toIndex])
        // Update event lables text
        eventLabel1.text = "\(fourRandomEvents[0].event)"
        eventLabel2.text = "\(fourRandomEvents[1].event)"
        eventLabel3.text = "\(fourRandomEvents[2].event)"
        eventLabel4.text = "\(fourRandomEvents[3].event)"
    }
    
    
    
}


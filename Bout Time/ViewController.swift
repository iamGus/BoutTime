//
//  ViewController.swift
//  Bout Time - Past UK Prime Mininsters and when they first came into power
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
    @IBOutlet weak var ShakeButton: UIButton!
    @IBOutlet weak var nextRoundButton: UIButton!
    
    
    // Properties to setup
    let dictionaryOfEvents: EventRounds
    var fourRandomEvents: [EventContent] // For each round this stores the active rounds random events, used to display and also check if events in active round are in correct order
    var timer = Timer()
    var counter = 0 // used with timer, timer starts at 0
    var roundTracking = GameRound() // Keeps score and amount of rounds completed data
    
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
        // Display first round
        displayround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Setup and display round
    func displayround() {
        
        
        // If user has completed all rounds then finish game and show user score
 
        if roundTracking.completed >= roundTracking.totalRounds {
            
            //end game and show score
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResultsController") as! ResultsController
            secondViewController.score = roundTracking.correct
            secondViewController.numberOfRounds = roundTracking.totalRounds
            self.present(secondViewController, animated: true, completion: nil)

        
        // If user has not completed all rounds then continue to display next round
            
        } else {
        //Hide next round button
        nextRoundButton.isHidden = true
        // Get four new random events
        fourRandomEvents = dictionaryOfEvents.nextRound() // update instance with the four random events
        eventLabel1.text = "\(fourRandomEvents[0].event)"
        eventLabel2.text = "\(fourRandomEvents[1].event)"
        eventLabel3.text = "\(fourRandomEvents[2].event)"
        eventLabel4.text = "\(fourRandomEvents[3].event)"
        
        // Show shake button
        ShakeButton.isHidden = false
        
        // Show and start counter
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 50.0, weight: UIFontWeightRegular)
        timerLabel.isHidden = false
        timerLabel.text = "0:00"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
           
        }
    }
    
    // End of round - check score and show correct or wrong button
    func checkRound(check answer: Bool) {
        
        //Hide timer and reset it for next round
        timerLabel.isHidden = true
        timer.invalidate() // Stop timer
        counter = 0 // Reset timer to 0
        
        
        ShakeButton.isHidden = true
        roundTracking.completed += 1 // Update tracker that another round completed
        if answer == true { // If events are in correct order
            roundTracking.correct += 1 // update score
            nextRoundButton.setImage(#imageLiteral(resourceName: "next_round_success"), for: UIControlState.normal)
            nextRoundButton.isHidden = false
        } else { // if events are not in correct order
            nextRoundButton.setImage(#imageLiteral(resourceName: "next_round_fail"), for: UIControlState.normal)
            nextRoundButton.isHidden = false
        }
        
    }
    
    
    // If phone is shaked while in round
    // Only runs if counter is still running meaning round still in play
    // So player cannot cheat and try and shake after round finished
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake && timer.isValid == true {
            let answer = dictionaryOfEvents.checkRound(orderOfQuestions: fourRandomEvents)
            checkRound(check: answer)
            
        }
    }
    
    
   // If one of the event arrow button pressed then rearrangeRound func activated
   
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
        let answer = dictionaryOfEvents.checkRound(orderOfQuestions: fourRandomEvents)
        checkRound(check: answer)
    }
    
    @IBAction func nextRound() {
        displayround()
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        roundTracking.completed = 0
        roundTracking.correct = 0
        displayround()
    }
    
    
    // Changes fourRandomEvent array order and updates buttons text fields
    func rearrangeRound(fromIndex: Int, toIndex: Int) {
        swap(&fourRandomEvents[fromIndex], &fourRandomEvents[toIndex])
        // Update event labels text
        eventLabel1.text = "\(fourRandomEvents[0].event)"
        eventLabel2.text = "\(fourRandomEvents[1].event)"
        eventLabel3.text = "\(fourRandomEvents[2].event)"
        eventLabel4.text = "\(fourRandomEvents[3].event)"
    }
    
    // Timer method
    
    func updateTimer() {
        if counter >= 60 {
            timer.invalidate()
            let answer = dictionaryOfEvents.checkRound(orderOfQuestions: fourRandomEvents)
            checkRound(check: answer)
        } else {
        counter += 1
        timerLabel.text = timeString(time: TimeInterval(counter))
        }
    }
    
    // Timer formatting
    
    func timeString(time: TimeInterval) -> String {
        
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%01i:%02i", minutes, seconds)
    }
    
}


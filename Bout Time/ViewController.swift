//
//  ViewController.swift
//  Bout Time
//
//  Created by Angus Muller on 22/05/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NewGameDelegate {

    //IBOulets
    @IBOutlet weak var eventLabel1: UILabel!
    @IBOutlet weak var eventLabel2: UILabel!
    @IBOutlet weak var eventLabel3: UILabel!
    @IBOutlet weak var eventLabel4: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var ShakeButton: UIButton!
    @IBOutlet weak var nextRoundButton: UIButton!
    
    
    
    // Propertoies to setup
    let dictionaryOfEvents: EventRounds
    var fourRandomEvents: [EventContent]
    let howManyRounds = 1
    var roundsCompleted = 0 // So game knows how many rounds it has already done
    var roundsCorrect = 0 // Counter to keep track of how many rounds correctly completed - for score
    var timer = Timer()
    var counter = 0
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup and display round
    func displayround() {
        
        /* ---------------------------
         If user has completed all rounds in howManyRounds then finish game and show user score
           ---------------------------- */
        
        if roundsCompleted >= howManyRounds {
            
            //end game and show score
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResultsController") as! ResultsController
            secondViewController.score = roundsCorrect
            secondViewController.numberOfRounds = howManyRounds
            self.present(secondViewController, animated: true, completion: nil)
 
            
            //self.navigationController?.pushViewController(secondViewController, animated: true)
            //self.performSegue(withIdentifier: "segue", sender: nil)
        // 
        // If user has not completed all rounds then contiue display next round
        //
            
        } else {
        //Hide next round button
        nextRoundButton.isHidden = true
        // Make new / update instance of next round questions
        fourRandomEvents = dictionaryOfEvents.nextRound()
        eventLabel1.text = "\(fourRandomEvents[0].event)"
        eventLabel2.text = "\(fourRandomEvents[1].event)"
        eventLabel3.text = "\(fourRandomEvents[2].event)"
        eventLabel4.text = "\(fourRandomEvents[3].event)"
        
        //Show shake button
        ShakeButton.isHidden = false
        
        //Show and start counter
        timerLabel.isHidden = false
        timerLabel.text = "0:00"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
           
        }
    }
    
    // End of round - check score and show correct or wrong button
    func checkRound(check answer: Bool) {
        
        //Hide timer and reset it for next round
        timerLabel.isHidden = true
        timer.invalidate()
        counter = 0
        
        
        ShakeButton.isHidden = true
        roundsCompleted += 1
        if answer == true {
            roundsCorrect += 1
            nextRoundButton.setImage(#imageLiteral(resourceName: "next_round_success"), for: UIControlState.normal)
            nextRoundButton.isHidden = false
        } else {
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
    
    // When user presses new game from other view reset counters and display round (new game)
    func userPressedNewGame(_ playAgain: Bool) {
        roundsCompleted = 0
        roundsCorrect = 0
        displayround()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back" {
            let secondVC = segue.destination as? ResultsController
            secondVC?.delegate = self
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
        let answer = dictionaryOfEvents.checkRound(orderOfQuestions: fourRandomEvents)
        checkRound(check: answer)
    }
    
    @IBAction func nextRound() {
        displayround()
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
    
    // Timer method
    
    func updateTimer() {
        if counter >= 60 {
            timer.invalidate()
            let answer = dictionaryOfEvents.checkRound(orderOfQuestions: fourRandomEvents) //NOTE repeated this three times now
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


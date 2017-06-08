//
//  ResultsController.swift
//  Bout Time
//
//  Created by Angus Muller on 07/06/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit

protocol NewGameDelegate {
    func userPressedNewGame(_ playAgain: Bool)
}

class ResultsController: UIViewController {
    
    
    @IBOutlet weak var scoreResultsLabel: UILabel!
    
    var delegate: NewGameDelegate! = nil
    
    var score = 0
    var numberOfRounds = 0

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update score label with results and total rounds completed
        scoreResultsLabel.text = "\(score)/\(numberOfRounds)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func playAgain(_ sender: Any) {
        delegate?.userPressedNewGame(true)
        dismiss(animated: true, completion: nil)
    
    }
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

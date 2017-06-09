//
//  ResultsController.swift
//  Bout Time
//
//  Created by Angus Muller on 07/06/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

// New viewController for score results and play again button

// Play again function uses unwind segue so no code for this action in here

import UIKit

class ResultsController: UIViewController {
    
    
    @IBOutlet weak var scoreResultsLabel: UILabel!
    
    // Setup properties taht will be passed from main ViewController
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
    
    }
  

}

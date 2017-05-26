//
//  ViewController.swift
//  Bout Time
//
//  Created by Angus Muller on 22/05/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //NOTE: Put IBOutlet weak here
    
    let roundOfEvents: [String: EachEvent] // NOTE this might change but currently set so can test what data import looks like
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try Plistconverter.dictionary(fromFile: "events", ofType: "plist")
            let inventory = try EventDataUnarchiver.eventData(fromDictionary: dictionary)
            self.roundOfEvents = inventory
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //test to see data in dictionary - it works!
        for (key, value) in roundOfEvents {
            print("\(key) happend in \(value.year)\n")
        }
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  ViewController.swift
//  Bottom Sheet Example
//
//  Created by Artashes Noknok on 7/28/21.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func showButonActtion(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        self.present(destinationVC, animated: false)
    }
    
    
    
    
    
}


//
//  ViewController.swift
//  MenuTransition
//
//  Created by Trevor Beasty on 8/24/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentSecond))
        view.addGestureRecognizer(tap)
    }

    func presentSecond() {
        let secondVc = storyboard!.instantiateViewController(withIdentifier: "second")
        present(secondVc, animated: true, completion: nil)
    }
}





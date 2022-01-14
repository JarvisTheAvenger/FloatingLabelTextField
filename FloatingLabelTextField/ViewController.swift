//
//  ViewController.swift
//  FloatingLabelTextField
//
//  Created by Rahul on 14/01/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var floatingTextField: FloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        floatingTextField.text = "Rahul"
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
}


//
//  ViewController.swift
//  RXSwiftLogin
//
//  Created by Kim on 2017/8/30.
//  Copyright © 2017年 Brain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var secondPasswordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var usernameTipLabel: UILabel!
    
    @IBOutlet weak var passwordTipLabel: NSLayoutConstraint!
    
    @IBOutlet weak var secondPasswordTipLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func registerButtonPress(_ sender: Any) {
    }


}


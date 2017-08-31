//
//  ViewController.swift
//  RXSwiftLogin
//
//  Created by Kim on 2017/8/30.
//  Copyright © 2017年 Brain. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class ViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var secondPasswordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var usernameTipLabel: UILabel!
    
    @IBOutlet weak var passwordTipLabel: NSLayoutConstraint!
    
    @IBOutlet weak var secondPasswordTipLabel: UILabel!
    
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = RegisterViewModel()
        
        usernameTextField.rx
            .text
            .orEmpty
            .bind(to: viewModel.username)
            .addDisposableTo(disposeBag)
        
        viewModel.usernameUseable
            .bind(to: usernameTipLabel.rx.checkResult)
            .addDisposableTo(disposeBag)
        viewModel.usernameUseable
            .bind(to: passwordTextField.rx.inpuEnabled)
            .addDisposableTo(disposeBag)
    }

    /// 点击注册按钮
    @IBAction func registerButtonPress(_ sender: Any) {
    }


}


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
    
    @IBOutlet weak var passwordTipLabel: UILabel!
    
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
        
        //绑定密码
        passwordTextField.rx
            .text
            .orEmpty
            .bind(to: viewModel.password)
            .addDisposableTo(disposeBag)
        
        secondPasswordTextField.rx
            .text
            .orEmpty
            .bind(to: viewModel.secondPassword)
            .addDisposableTo(disposeBag)
        
        viewModel.passwordUseable
            .bind(to: passwordTipLabel.rx.checkResult)
            .addDisposableTo(disposeBag)
        
        viewModel.passwordUseable
            .bind(to: secondPasswordTextField.rx.inpuEnabled)
            .addDisposableTo(disposeBag)
        
        viewModel.secondPasswordUseable
            .bind(to: secondPasswordTipLabel.rx.checkResult)
            .addDisposableTo(disposeBag)
        
        //绑定注册按钮
        registerButton.rx
            .tap
            .bind(to: viewModel.registerTap)//需要硬敲
            .addDisposableTo(disposeBag)
        
        viewModel.registerButtonEnabled
            .subscribe(onNext: { [unowned self] valid in
                self.registerButton.isEnabled = valid
                self.registerButton.alpha = valid ? 1.0 : 0.5
            })
            .addDisposableTo(disposeBag)
        
        viewModel.registerResult
            .subscribe(onNext: {[unowned self] result in
                switch result {
                case let .ok(message):
                    self.showAlert(message: message)
                case .empty:
                    self.showAlert(message: "")
                case let .failed(message):
                    self.showAlert(message: message)
                }
            })
            .addDisposableTo(disposeBag)
    }

    /// 点击注册按钮
    @IBAction func registerButtonPress(_ sender: Any) {
    }

    /// 弹窗方法
    ///
    /// - Parameter message: 需要显示的信息
    func showAlert(message: String) {
        if message == "" {
            print("消息为空了。。。。。。")
            return
        }
        
        let alertViewVontroller = UIAlertController(title: "", message: message, preferredStyle: .alert)
        //添加一个确定按钮
        let action = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertViewVontroller.addAction(action)
        
        present(alertViewVontroller, animated: true, completion: nil)
    }
}


//
//  LoginViewController.swift
//  RXSwiftLogin
//
//  Created by Kim on 2017/8/30.
//  Copyright © 2017年 Brain. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var usernameTipLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordTipLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    var viewModel: LoginViewModel!
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = LoginViewModel(input: (username: usernameTextField.rx.text.orEmpty.asDriver(),
                                           password: passwordTextField.rx.text.orEmpty.asDriver(),
                                           buttonTaps: loginButton.rx.tap.asDriver()), service: CheckService.instance)
        
        viewModel.usernameUsable
            .drive(usernameTipLabel.rx.checkResult)
            .addDisposableTo(disposeBag)
        
        viewModel.loginButtonEnabled
            .drive(onNext: {[unowned self] valid in
                self.loginButton.isEnabled = valid
                self.loginButton.alpha = valid ? 1.0 : 0.5
            })
            .addDisposableTo(disposeBag)
        
        viewModel.loginResult
            .drive(onNext: {[unowned self] result in
                switch result {
                case let .ok(message):
                    self.showAlert(message: message)
                case let .failed(message):
                    self.showAlert(message: message)
                case .empty:
                    self.showAlert(message: "")
                }
            })
            .addDisposableTo(disposeBag)
    }

    @IBAction func loginButtonTap(_ sender: Any) {
        
        
        
    }
    
    /// 弹窗显示登录结果
    ///
    /// - Parameter message: 消息内容
    func showAlert(message: String)  {
        if message == "" {
            print("消息为空")
            return
        }
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "确定", style: .default) { _ in
            self.performSegue(withIdentifier: "showHome", sender: self)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
}

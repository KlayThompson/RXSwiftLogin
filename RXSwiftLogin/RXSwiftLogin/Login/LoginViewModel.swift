//
//  LoginViewModel.swift
//  RXSwiftLogin
//
//  Created by Kim on 2017/9/1.
//  Copyright © 2017年 Brain. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class LoginViewModel {
    
    //output
    let usernameUsable: Driver<Result>
    let loginButtonEnabled: Driver<Bool>
    let loginResult: Driver<Result>
    
    
    init(input: (username: Driver<String>, password: Driver<String>, buttonTaps: Driver<Void>), service: CheckService) {
        
        usernameUsable = input.username
            .flatMapLatest({ (username) in
                return service.loginUsernameValid(username: username)
                        .asDriver(onErrorJustReturn: .failed(message: "连接服务失败"))
            })
        
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) {
            ($0,$1)
        }
        
        loginResult = input.buttonTaps
            .withLatestFrom(usernameAndPassword)
            .flatMapLatest({ (username, password) in
                return service.login(username: username, password: password)
                    .asDriver(onErrorJustReturn: .failed(message: "连接服务失败"))
            })
        
        loginButtonEnabled = input.password
            .map{
                $0.characters.count > 0
            }
            .asDriver()
        
    }
    
}

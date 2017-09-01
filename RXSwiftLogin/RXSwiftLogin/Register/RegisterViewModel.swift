//
//  RegisterViewModel.swift
//  RXSwiftLogin
//
//  Created by Kim on 2017/8/31.
//  Copyright © 2017年 Brain. All rights reserved.
//

import Foundation
import RxSwift

class RegisterViewModel {
    //input
    let username = Variable<String>("")
    let password = Variable<String>("")
    let secondPassword = Variable<String>("")
    let registerTap = PublishSubject<Void>()
    
    
    //output
    let usernameUseable: Observable<Result>
    let passwordUseable: Observable<Result>//密码是否可用
    let secondPasswordUseable: Observable<Result>//密码确定是否一致
    let registerButtonEnabled: Observable<Bool>
    let registerResult: Observable<Result>
    
    
    
    
    init() {
        
        let checkBox = CheckBox.instance
        let service = CheckService.instance
        

        usernameUseable = username.asObservable()
            .flatMapLatest{ username in
                return checkBox.checkUsername(name: username)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(.failed(message: "username检测出错"))
            }
            .shareReplay(1)
        
        passwordUseable = password.asObservable()
            .map({ (password) in
                return service.checkPassword(password: password)
            })
            .shareReplay(1)
        
        secondPasswordUseable = Observable.combineLatest(password.asObservable(), secondPassword.asObservable()) {
            return service.checkSecondPassword(password: $0, secondPassword: $1)
        }
            .shareReplay(1)
        
        //将做username，password，secondPassword三个结果绑定在一起形成一个结果流，是一个bool值得流
        registerButtonEnabled = Observable.combineLatest(usernameUseable, passwordUseable, secondPasswordUseable) { (username, password, secondPassword) in
            username.isValid && password.isValid && secondPassword.isValid
        }
            .distinctUntilChanged()
            .shareReplay(1)
        
        //用户名密码observe
        let usernameAndPassword = Observable.combineLatest(username.asObservable(), password.asObservable()) {
            ($0,$1)
        }
        
        //对registerTaps事件进行监听，我们拿到每一个元组进行注册行为，涉及到耗时数据库操作，我们需要对这个过程进行监听，所以我们使用flatMap函数，返回一个新的流
        registerResult = registerTap.asObservable()
                .withLatestFrom(usernameAndPassword)
                .flatMapLatest({ (username, password)  in
                    return service.register(username: username, password: password)
                                .observeOn(MainScheduler.instance)
                        .catchErrorJustReturn(.failed(message: "注册出错"))
                })
                .shareReplay(1)
    }
}

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
    
    //output
    let usernameUseable: Observable<Result>
    
    init() {
        
        let checkBox = CheckBox.instance

        usernameUseable = username.asObservable()
            .flatMapLatest{ username in
                return checkBox.checkUsername(name: username)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(.failed(message: "username检测出错"))
            }
            .shareReplay(1)
    }
}

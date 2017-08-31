//
//  CheckBox.swift
//  RXSwiftLogin
//
//  Created by Kim on 2017/8/30.
//  Copyright © 2017年 Brain. All rights reserved.
//

///验证类，设计成单利模式
import Foundation
import RxSwift
import RxCocoa

class CheckBox {
    
    static let instance = CheckBox()
    
    let miniCount = 6
    
    
    private init() {
    }
    
    //这里面我们返回一个Observable对象，因为我们这个请求过程需要被监听。
    func checkUsername(name: String) -> Observable<Result> {
        
        //当为空的时候啥也不做
        if name.characters.count == 0 {
            return .just(.empty)
        }
        
        //当长度小于6时候返回failed
        if name.characters.count < miniCount {
            return .just(.failed(message: "号码长度至少6个"))
        }
        
        //检测数据库中是否存在此名字
        if usernameCheck(username: name) {
            return .just(.failed(message: "用户名已存在"))
        }
        
        //返回成功
        return .just(.ok(message: "用户名可用"))
    }
    
    //检测用户名是否在数据库中存在
    func usernameCheck(username: String) -> Bool {
        
        let filePath = NSHomeDirectory() + "/Documents/users.plist"
        let userDic = NSDictionary(contentsOfFile: filePath)
        guard let userDictionary = userDic else {
            return false
        }
        let userNameArray = userDictionary.allKeys as NSArray
        
        if userNameArray.contains(username) {
            return true
        }
        
        return false
    }
    
}

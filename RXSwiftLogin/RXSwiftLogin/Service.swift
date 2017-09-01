//
//  Service.swift
//  RXSwiftLogin
//
//  Created by Kim on 2017/9/1.
//  Copyright © 2017年 Brain. All rights reserved.
//

import Foundation
import RxSwift

class CheckService {
    
    static let instance = CheckService()
    
    let miniCount = 6
    
    
    private init() {
        
    }
    
    /// 检测设置密码是否可用
    ///
    /// - Parameter password: 设置的密码
    /// - Returns: 结果
    func checkPassword(password: String) -> Result {
        //为空情况
        if password.characters.count == 0 {
            return .empty
        }
        
        //小于6位情况
        if password.characters.count < miniCount {
            return .failed(message: "密码长度至少6个字符")
        }
        
        //密码可用
        return .ok(message: "密码可用")
    }
    
    /// 检测验证密码是否一致
    ///
    /// - Parameters:
    ///   - password: 第一次设置的密码
    ///   - secondPassword: 第二次设置的密码
    /// - Returns: 结果
    func checkSecondPassword(password: String, secondPassword: String) -> Result {
        
        if secondPassword.characters.count == 0 {
            return .empty
        }
        
        if password == secondPassword {
            return .ok(message: "密码可用")
        }
        
        return .failed(message: "两次密码不一致")
    }
    
    /// 注册用户，成功保存本地，不成功提示失败
    ///
    /// - Parameters:
    ///   - username: 用户名
    ///   - password: 密码
    /// - Returns: 观察信号
    func register(username: String, password: String) -> Observable<Result> {
        
        let userDic = [username : password] as NSDictionary
        //拼接路径
        let filePath = NSHomeDirectory() + "/Documents/users.plist"
        
        if userDic.write(toFile: filePath, atomically: true) {
            return .just( .ok(message: "注册成功"))
        }
        return .just( .failed(message: "注册失败"))
    }
}

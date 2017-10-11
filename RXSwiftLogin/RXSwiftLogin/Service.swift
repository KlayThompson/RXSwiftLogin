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

// MARK: - 用户登录相关
extension CheckService {

    /// 检查用户名是否可用
    ///
    /// - Parameter username: 用户名
    /// - Returns: 观察
    func loginUsernameValid(username: String) -> Observable<Result> {
        
        let checkBox = CheckBox.instance
        
        
        //为空
        if username.characters.count == 0 {
            return .just(.empty)
        }
        
        if checkBox.usernameCheck(username: username) {
            return .just(.ok(message: "用户名可用"))
        }
        
        return .just(.failed(message: "用户名不存在"))
    }
    
    /// 用户登录
    ///
    /// - Parameters:
    ///   - username: 用户名
    ///   - password: 密码
    /// - Returns: 观察
    func login(username: String, password: String) -> Observable<Result> {
        
        //获取plist文件中的用户字典
        let filePath = NSHomeDirectory() + "/Documents/users.plist"
        
        let dic = NSDictionary(contentsOfFile: filePath)
        
        guard let userDic = dic else {
            return .just( .failed(message: "获取本地用户信息失败"))
        }
        
        let userPass = userDic.object(forKey: username) as? String
        
        guard let userPassword = userPass  else {
            return .just(.failed(message: "密码错误"))
        }
        
        if userPassword == password {
            return .just(.ok(message: "登录成功"))
        }
        return .just(.failed(message: "密码错误"))
    }
    
}

// MARK: - 搜索英雄相关
extension CheckService {
   
    
    /// 获取英雄数组
    ///
    /// - Returns: 观察
    func getHeros() -> Observable<[Hero]> {
        
        var heros = [Hero]()
        //利用guard来守护
        guard let filePath = Bundle.main.path(forResource: "heros", ofType: "plist"),
        let heroArray = NSArray(contentsOfFile: filePath) as? Array<[String:String]> else {
            return Observable.just(heros).observeOn(MainScheduler.instance)
        }
        
        //遍历英雄数组
        for heroDic in heroArray {
            let hero = Hero(name: heroDic["name"], desc: heroDic["intro"], imageString: heroDic["icon"])
            heros.append(hero)
        }
        
        return Observable
                .just(heros)
                .observeOn(MainScheduler.instance)
    }
    
    /// 根据英雄名字进行查找
    ///
    /// - Parameter name: 英雄名
    /// - Returns: 返回
    func getHeroWithName(name: String) -> Observable<[Hero]> {
        
        //若果name为空
        if name == "" {
            return getHeros()
        }
        
        var heros = [Hero]()
        
        guard let filePath = Bundle.main.path(forResource: "heros", ofType: "plist"),
            let heroArray = NSArray(contentsOfFile: filePath) as? Array<[String:String]> else {
                return Observable.just(heros).observeOn(MainScheduler.instance)
        }
        
        //遍历英雄数组
        for heroDic in heroArray {
            if heroDic["name"]!.contains(name) {//先不管了，强制解包
                let hero = Hero(name: heroDic["name"], desc: heroDic["intro"], imageString: heroDic["icon"])
                heros.append(hero)
            }
        }
        return Observable
            .just(heros)
            .observeOn(MainScheduler.instance)
    }
}

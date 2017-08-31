//
//  protocol.swift
//  RXSwiftLogin
//
//  Created by Kim on 2017/8/30.
//  Copyright © 2017年 Brain. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

enum Result {
    case ok(message: String)
    case empty
    case failed(message: String)
}

// MARK: - 是否验证
extension Result {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

// MARK: - 字体颜色
extension Result {
    var textColor: UIColor {
        switch self {
        case .ok:
            return UIColor(red: 138.0 / 255.0, green: 221.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
        case .empty:
            return UIColor.black
        case .failed:
            return UIColor.red
        }
    }
}

extension Result {
    var description: String {
        switch self {
        case let .ok(message):
            return message
        case .empty:
            return ""
        case let .failed(message):
            return message
        }
    }
    

}

extension Reactive where Base: UILabel {
    var checkResult: UIBindingObserver<Base, Result> {
        return UIBindingObserver(UIElement: base, binding: { (label, result) in
            label.textColor = result.textColor
            label.text = result.description
        })
    }
    
}

extension Reactive where Base: UITextField {
    var inpuEnabled: UIBindingObserver<Base, Result> {
        return UIBindingObserver(UIElement: base, binding: { (textField, result) in
            textField.isEnabled = result.isValid
        })
    }
    
}







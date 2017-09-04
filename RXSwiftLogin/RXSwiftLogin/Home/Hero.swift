//
//  Hero.swift
//  RXSwiftLogin
//
//  Created by Kim on 2017/9/4.
//  Copyright © 2017年 Brain. All rights reserved.
//

import Foundation

class Hero: NSObject {
    
    var name: String?
    var desc: String?
    var imageString: String?
    
    init(name: String?, desc: String?, imageString: String? ) {
        
        self.name = name
        self.desc = desc
        self.imageString = imageString
    }
}

//
//  StickerData.swift
//  Example
//
//  Created by Radif Sharafullin on 8/24/16.
//  Copyright © 2016 Radif Sharafullin. All rights reserved.
//

import Foundation

struct StickerData{
    let images:[String]
    let name:String
    let fps:Float
    var frameDelay:Float{ get{ return 1.0/fps } }
}

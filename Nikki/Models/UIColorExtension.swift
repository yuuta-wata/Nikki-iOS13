//
//  UIColorExtension.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2020/01/16.
//  Copyright © 2020 Yuta Watanabe. All rights reserved.
//

import UIKit

// UIColorの拡張
extension UIColor {

    // 16進数のカラーコードをiOSの設定に変換するメソッド
    convenience init(code: String, alpha: CGFloat = 1.0) {
        var color: UInt64 = 0
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        if Scanner(string: code.replacingOccurrences(of: "#", with: "")).scanHexInt64(&color){
            r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            g = CGFloat((color & 0x00FF00) >>  8) / 255.0
            b = CGFloat( color & 0x0000FF       ) / 255.0
        }
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

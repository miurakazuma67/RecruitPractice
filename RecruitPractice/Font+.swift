//
//  Font+.swift
//  RecruitPractice
//
//  Created by 三浦　一真 on 2024/01/02.
//
import SwiftUI

extension Font {
    /// NotoSansJP-Regular指定時に使用
    static func notoRegular(size: CGFloat) -> Font {
        return Font.custom("NotoSansJP-Regular", size: size)
    }

    /// NotoSansJP-Bold指定時に使用
    static func notoBold(size: CGFloat) -> Font {
        return Font.custom("NotoSansJP-Bold", size: size)
    }
}

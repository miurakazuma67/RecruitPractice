//
//  ColorImageButton.swift
//  RecruitPractice
//
//  Created by 三浦　一真 on 2024/01/09.
//

import SwiftUI

struct ColorImageButton: View {
    let imageName: String //画像名
    let foregroundColor: Color //タイトルの色
    let backgroundColor: Color //背景色
    let width: CGFloat
    let height: CGFloat
    let buttonText: String //ボタンタイトル
    let action: () -> Void // タップ時の処理
    let borderContain: Bool // ボーダーをつけるかどうか

    var body: some View {
        Button(action: {
            action()
        })
        {
            if borderContain {
                HStack {
                    VStack {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: width, height: height)

                        Text(buttonText)
                            .font(.notoBold(size: 10))
                            .foregroundColor(foregroundColor)
                    }
                    .padding([.leading, .trailing], width == 90 ? 20 : 0)
                    .background(backgroundColor)
                    .frame(width: width, height: height)
                    .border(Color.primaryBlue, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                }
            }
            else
            {
                HStack {
                    VStack {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)

                        Text(buttonText)
                            .font(.notoBold(size: 10))
                            .foregroundColor(foregroundColor)
                    }
                    .padding([.leading, .trailing], 20)
                    .background(backgroundColor)
                    .frame(width: width, height: height)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

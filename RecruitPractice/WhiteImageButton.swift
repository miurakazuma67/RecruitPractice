//
//  WhiteImageButton.swift
//  RecruitPractice
//
//  Created by 三浦　一真 on 2024/01/09.
//

import SwiftUI

struct WhiteImageButton: View {
    let imageName: String
    let backgroundColor: Color
    let buttonText: String
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                VStack {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)

                    Text(buttonText)
                        .font(.notoBold(size: 10))
                        .foregroundColor(Color.white)
                }
                .padding([.leading, .trailing], 20)
                .background(backgroundColor)
                .frame(width: 90, height: 40)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

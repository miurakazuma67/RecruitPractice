//
//  ScalableImageView.swift
//  RecruitPractice
//
//  Created by 三浦　一真 on 2024/01/02.
//

import SwiftUI

// SVG画像表示対応のため、UIImageViewを使用するためのView(参考: https://qiita.com/toshi0383/items/8cb2709be6d2f4442f27)
struct ScalableImageView: UIViewRepresentable {
    let image: UIImage

    init(_ image: UIImage) {
        self.image = image
    }

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.image = image
    }
}

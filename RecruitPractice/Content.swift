//
//  Model.swift
//  RecruitPractice
//
//  Created by 三浦　一真 on 2024/01/03.
//

import Foundation

struct Content: Codable {
    let id: Int
    let title: String
    let body: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
    }
}

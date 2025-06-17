//
//  Recording.swift
//  OwnVoice
//
//  Created by me on 2025/06/13.
//

import Foundation

struct Recording: Codable, Identifiable {
    let id: String
    let text: String
    let date: Date
}

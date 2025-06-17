//
//  RecordingStorage.swift
//  OwnVoice
//
//  Created by me on 2025/06/13.
//

import Foundation

class RecordingStorage {
    static let key = "savedRecordings"
    
    static func saveRecordings(_ recordings: [Recording]) {
        if let encoded = try? JSONEncoder().encode(recordings) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    static func loadRecordings() -> [Recording] {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Recording].self, from: data) {
            return decoded
        }
        return []
    }
}

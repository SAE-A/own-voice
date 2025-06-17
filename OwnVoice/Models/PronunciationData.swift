//
//  PronunciationData.swift
//  OwnVoice
//
//  Created by me on 2025/06/17.
//

import Foundation

struct PronunciationText {
    let id: String
    let text: String
    let difficulty: PronunciationDifficulty
}

enum PronunciationDifficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

class PronunciationDataManager {
    static let shared = PronunciationDataManager()
    
    private let pronunciationTexts: [PronunciationText] = [
        // 쉬운 단계
        PronunciationText(id: "1", text: "나는 오늘 학교에 갔다", difficulty: .easy),
        PronunciationText(id: "2", text: "고양이가 창밖을 바라본다", difficulty: .easy),
        PronunciationText(id: "3", text: "비가 와서 우산을 썼다", difficulty: .easy),
        PronunciationText(id: "4", text: "친구와 함께 영화를 봤다", difficulty: .easy),
        PronunciationText(id: "5", text: "사과가 아주 맛있어요", difficulty: .easy),
        
        // 보통 단계
        PronunciationText(id: "6", text: "철수는 칠판에 깨끗하게 글씨를 썼다", difficulty: .medium),
        PronunciationText(id: "7", text: "빠르게 뛰어가다 갑자기 멈췄다", difficulty: .medium),
        PronunciationText(id: "8", text: "햇살이 유리창 너머로 반짝였다", difficulty: .medium),
        PronunciationText(id: "9", text: "지하철 안에서 조용히 책을 읽었다", difficulty: .medium),
        PronunciationText(id: "10", text: "선생님께 정중하게 질문을 드렸다", difficulty: .medium),
        
        // 어려운 단계
        PronunciationText(id: "11", text: "경찰청 철창살은 외철창살인가 쌍철창살인가", difficulty: .hard),
        PronunciationText(id: "12", text: "저 분은 백 법학 박사입니다.", difficulty: .hard),
        PronunciationText(id: "13", text: "숲속 수풀 사이로 사슴이 살금살금", difficulty: .hard),
        PronunciationText(id: "14", text: "청천벽력 같은 청첩장이 도착했다", difficulty: .hard),
        PronunciationText(id: "15", text: "서울 숲 속 소슬바람은 솔솔 분다", difficulty: .hard)
    ]
    
    private init() {}
    
    func getRandomText(difficulty: PronunciationDifficulty? = nil) -> PronunciationText {
        let filteredTexts: [PronunciationText]
        
        if let difficulty = difficulty {
            filteredTexts = pronunciationTexts.filter { $0.difficulty == difficulty }
        } else {
            filteredTexts = pronunciationTexts
        }
        
        return filteredTexts.randomElement() ?? pronunciationTexts[0]
    }
    
    func getAllTexts() -> [PronunciationText] {
        return pronunciationTexts
    }
}

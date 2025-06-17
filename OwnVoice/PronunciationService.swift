//
//  PronunciationService.swift
//  OwnVoice
//
//  Created by me on 2025/06/17.
//

import Foundation
import AVFoundation
import Speech

protocol PronunciationServiceDelegate: AnyObject {
    func pronunciationServiceDidUpdateTranscription(_ text: String)
    func pronunciationServiceDidFinishRecording(success: Bool)
    func pronunciationServiceDidCompareTexts(similarity: Double, feedback: String)
}

class PronunciationService: NSObject, SFSpeechRecognizerDelegate {
    
    weak var delegate: PronunciationServiceDelegate?
    
    private var audioRecorder: AVAudioRecorder?
    private var audioEngine = AVAudioEngine()
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private(set) var isRecording = false
    private(set) var transcribedText = ""
    private var targetText = ""
    
    override init() {
        super.init()
        
        // Set up speech recognizer
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
        speechRecognizer?.delegate = self
        
        // Request authorization
        SFSpeechRecognizer.requestAuthorization { status in
            // Handle authorization status
        }
    }
    
    func startRecording(targetText: String) {
        self.targetText = targetText
        
        // Reset previous recording session if any
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Set up audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
            return
        }
        
        // Set up recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            print("Unable to create recognition request")
            return
        }
        
        // Configure request
        recognitionRequest.shouldReportPartialResults = true
        
        // Start recognition task
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            var isFinal = false
            
            if let result = result {
                // Update transcribed text
                self.transcribedText = result.bestTranscription.formattedString
                self.delegate?.pronunciationServiceDidUpdateTranscription(self.transcribedText)
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                // Stop audio engine when done
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.delegate?.pronunciationServiceDidFinishRecording(success: error == nil)
                
                // Compare texts after recording is finished
                if error == nil {
                    self.compareTexts()
                }
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            isRecording = true
        } catch {
            print("Audio engine failed to start: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        isRecording = false
    }
    
    private func compareTexts() {
        let similarity = calculateSimilarity(original: targetText, transcribed: transcribedText)
        let feedback = generateFeedback(similarity: similarity, original: targetText, transcribed: transcribedText)
        
        delegate?.pronunciationServiceDidCompareTexts(similarity: similarity, feedback: feedback)
    }
    
    private func calculateSimilarity(original: String, transcribed: String) -> Double {
        let originalCleaned = original.replacingOccurrences(of: " ", with: "").lowercased()
        let transcribedCleaned = transcribed.replacingOccurrences(of: " ", with: "").lowercased()
        
        let distance = levenshteinDistance(originalCleaned, transcribedCleaned)
        let maxLength = max(originalCleaned.count, transcribedCleaned.count)
        
        if maxLength == 0 {
            return 1.0
        }
        
        let similarity = 1.0 - (Double(distance) / Double(maxLength))
        return max(0.0, similarity)
    }
    
    // 유사도 계산 (원 문장 - 녹음된 문장)
    private func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
        let s1Array = Array(s1)
        let s2Array = Array(s2)
        let s1Count = s1Array.count
        let s2Count = s2Array.count
        
        var matrix = Array(repeating: Array(repeating: 0, count: s2Count + 1), count: s1Count + 1)
        
        for i in 0...s1Count {
            matrix[i][0] = i
        }
        
        for j in 0...s2Count {
            matrix[0][j] = j
        }
        
        for i in 1...s1Count {
            for j in 1...s2Count {
                let cost = s1Array[i-1] == s2Array[j-1] ? 0 : 1
                matrix[i][j] = min(
                    matrix[i-1][j] + 1,      // 삭제
                    matrix[i][j-1] + 1,      // 삽입
                    matrix[i-1][j-1] + cost  // 대체
                )
            }
        }
        
        return matrix[s1Count][s2Count]
    }
    
    private func generateFeedback(similarity: Double, original: String, transcribed: String) -> String {
        let percentage = Int(similarity * 100)
        
        switch percentage {
        case 90...100:
            return "Perfect! 🎉\nAccuracy: \(percentage)%"
        case 80..<90:
            return "Great job! 👏\nAccuracy: \(percentage)%\nJust a little more practice to make it perfect."
        case 70..<80:
            return "Good effort! 👍\nAccuracy: \(percentage)%\nTry to pronounce a bit more clearly."
        case 60..<70:
            return "Not bad! 😊\nAccuracy: \(percentage)%\nSpeak slowly and clearly."
        case 50..<60:
            return "Keep trying! 💪\nAccuracy: \(percentage)%\nReview the sentence and practice again."
        default:
            return "Try again! 🔄\nAccuracy: \(percentage)%\nRead the sentence slowly and repeat it."
        }
    }
}

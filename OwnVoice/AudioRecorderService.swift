//
//  AudioRecorderService.swift
//  OwnVoice
//
//  Created by me on 2025/06/13.
//

import Foundation
import AVFoundation
import Speech

protocol AudioRecorderDelegate: AnyObject {
    func audioRecorderDidUpdateTranscription(_ text: String)
    func audioRecorderDidFinishRecording(success: Bool)
}

class AudioRecorderService: NSObject, SFSpeechRecognizerDelegate {
    
    weak var delegate: AudioRecorderDelegate?
    
    private var audioRecorder: AVAudioRecorder?
    private var audioEngine = AVAudioEngine()
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var recordingURL: URL?
    
    private(set) var isRecording = false
    private(set) var transcribedText = ""
    
    override init() {
        super.init()
        
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
        speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { status in }
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        recordingURL = documentsPath.appendingPathComponent("recording.m4a")
    }
    
    func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
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
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            var isFinal = false
            
            if let result = result {
                // Update transcribed text
                self.transcribedText = result.bestTranscription.formattedString
                self.delegate?.audioRecorderDidUpdateTranscription(self.transcribedText)
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                // Stop audio engine when done
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.delegate?.audioRecorderDidFinishRecording(success: error == nil)
            }
        }
        
        // Configure audio engine
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.removeTap(onBus: 0)
            audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.recognitionRequest?.append(buffer)
            }
        
        // Start audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
            isRecording = true
        } catch {
            print("Audio engine failed to start: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        recognitionRequest?.endAudio()
        isRecording = false
    }
    
    func saveRecording() -> Recording? {
        guard !transcribedText.isEmpty else { return nil }
        
        // Create a recording object
        let recording = Recording(
            id: UUID().uuidString,
            text: transcribedText,
            date: Date()
        )
        
        var recordings = RecordingStorage.loadRecordings()
        
        // Add new recording
        recordings.append(recording)
        
        // Save updated recordings
        RecordingStorage.saveRecordings(recordings)
        
        // Reset transcribed text
        let savedRecording = recording
        transcribedText = ""
        
        return savedRecording
    }
}

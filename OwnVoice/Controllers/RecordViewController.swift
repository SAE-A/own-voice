//
//  RecordViewController.swift
//  OwnVoice
//
//  Created by me on 2025/06/13.
//

import Foundation
import UIKit
import AVFoundation

class RecordViewController: UIViewController {
    
    // UI Elements
    private let statusLabel = UILabel()
    private let transcriptionTextView = UITextView()
    private let recordButton = UIButton()
    private let saveButton = UIButton()
    
    // Audio recorder service
    private let audioRecorder = AudioRecorderService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupAudioRecorder()
        
        // Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Logo setup
        let logoView = LogoView()
        view.addSubview(logoView)
        
        logoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -40),
            logoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -70),
            logoView.widthAnchor.constraint(equalToConstant: 240),
            logoView.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        // Status label setup
        statusLabel.text = ""
        statusLabel.font = UIFont.boldSystemFont(ofSize: 24)
        statusLabel.textColor = UIColor(hex: "4A2511")
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        view.addSubview(statusLabel)
        
        // Transcription text view setup
        transcriptionTextView.font = UIFont.systemFont(ofSize: 16)
        transcriptionTextView.textColor = UIColor(hex: "4A2511")
        transcriptionTextView.backgroundColor = UIColor(hex: "FFEEEE").withAlphaComponent(0.3)
        transcriptionTextView.layer.cornerRadius = 10
        transcriptionTextView.isEditable = false
        view.addSubview(transcriptionTextView)
        
        // Record button setup
        recordButton.backgroundColor = UIColor(hex: "B33B1C")
        recordButton.setTitle("REC", for: .normal)
        recordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        recordButton.setTitleColor(.white, for: .normal)
        recordButton.layer.cornerRadius = 50
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        view.addSubview(recordButton)
        
        // Save button setup
        saveButton.backgroundColor = UIColor(hex: "B33B1C")
        saveButton.setTitle("Save to Diary", for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        saveButton.titleLabel?.numberOfLines = 2
        saveButton.titleLabel?.textAlignment = .center
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.isEnabled = false
        view.addSubview(saveButton)
        
        // Set up constraints
        setupConstraints()
    }
    
    private func setupConstraints() {
        // Make all views use autolayout
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        transcriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Status label constraints
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Transcription text view constraints
            transcriptionTextView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            transcriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            transcriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            transcriptionTextView.heightAnchor.constraint(equalToConstant: 200),
            
            // Record button constraints
            recordButton.topAnchor.constraint(equalTo: transcriptionTextView.bottomAnchor, constant: 40),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.widthAnchor.constraint(equalToConstant: 100),
            recordButton.heightAnchor.constraint(equalToConstant: 100),
            
            // Save button constraints
            saveButton.topAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: 30),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupAudioRecorder() {
        audioRecorder.delegate = self
    }
    
    @objc private func recordButtonTapped() {
        if audioRecorder.isRecording {
            audioRecorder.stopRecording()
            recordButton.backgroundColor = UIColor(hex: "B33B1C")
        } else {
            audioRecorder.startRecording()
            recordButton.backgroundColor = UIColor.red
            statusLabel.text = "Recording ..."
        }
    }
    
    @objc private func saveButtonTapped() {
        if audioRecorder.saveRecording() != nil {
            // Show success alert
            let alert = UIAlertController(
                title: "Save Successful",
                message: "Your recording has been saved\nto the Diary",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Check", style: .default) { [weak self] _ in
                // Switch to diary tab
                self?.tabBarController?.selectedIndex = 1
            })
            
            present(alert, animated: true)
            
            // Reset UI
            transcriptionTextView.text = ""
            saveButton.isEnabled = false
        }
    }
}

// MARK: - AudioRecorderDelegate
extension RecordViewController: AudioRecorderDelegate {
    func audioRecorderDidUpdateTranscription(_ text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.transcriptionTextView.text = text
            self?.saveButton.isEnabled = !text.isEmpty
        }
    }
    
    func audioRecorderDidFinishRecording(success: Bool) {
        DispatchQueue.main.async { [weak self] in
            if success {
                self?.statusLabel.text = "Recording Completed"
            } else {
                self?.statusLabel.text = "Recording Failed"
            }
        }
    }
}

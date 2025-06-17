//
//  PronunciationViewController.swift
//  OwnVoice
//
//  Created by me on 2025/06/17.
//

import Foundation
import UIKit
import AVFoundation

class PronunciationViewController: UIViewController {
    
    // UI Elements
    private let difficultySegmentedControl = UISegmentedControl(items: ["Easy", "Medium", "Hard"])
    private let targetTextLabel = UILabel()
    private let transcribedTextLabel = UILabel()
    private let recordButton = UIButton()
    private let retryButton = UIButton()
    private let newTextButton = UIButton()
    private let feedbackLabel = UILabel()
    private let accuracyProgressView = UIProgressView()
    private let accuracyLabel = UILabel()
    
    // Services
    private let pronunciationService = PronunciationService()
    private var currentText: PronunciationText?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupPronunciationService()
        loadNewText()
        
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
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Pronunciation Practice & Feedback"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.font = UIFont.italicSystemFont(ofSize: titleLabel.font.pointSize)
        titleLabel.textColor = UIColor(hex: "4A2511")
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        // Difficulty selector
        difficultySegmentedControl.selectedSegmentIndex = 0
        difficultySegmentedControl.addTarget(self, action: #selector(difficultyChanged), for: .valueChanged)
        view.addSubview(difficultySegmentedControl)
        
        // Target text container
        let targetTextContainer = UIView()
        targetTextContainer.backgroundColor = UIColor(hex: "F7C6C7")
        targetTextContainer.layer.cornerRadius = 10
        targetTextContainer.layer.borderWidth = 1
        targetTextContainer.layer.borderColor = UIColor(hex: "4A2511").cgColor
        view.addSubview(targetTextContainer)
        
        let targetTextTitleLabel = UILabel()
        targetTextTitleLabel.text = "📖 Practice Sentence"
        targetTextTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        targetTextTitleLabel.textColor = UIColor(hex: "4A2511")
        targetTextContainer.addSubview(targetTextTitleLabel)
        
        targetTextLabel.font = UIFont.systemFont(ofSize: 18)
        targetTextLabel.textColor = UIColor(hex: "4A2511")
        targetTextLabel.numberOfLines = 0
        targetTextLabel.textAlignment = .center
        targetTextLabel.lineBreakMode = .byWordWrapping
        targetTextContainer.addSubview(targetTextLabel)
        
        // Transcribed text container
        let transcribedTextContainer = UIView()
        transcribedTextContainer.backgroundColor = UIColor(hex: "A8D5BA")
        transcribedTextContainer.layer.cornerRadius = 10
        transcribedTextContainer.layer.borderWidth = 1
        transcribedTextContainer.layer.borderColor = UIColor(hex: "4A2511").cgColor
        view.addSubview(transcribedTextContainer)
        
        let transcribedTextTitleLabel = UILabel()
        transcribedTextTitleLabel.text = "🎤 Recognized Speech"
        transcribedTextTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        transcribedTextTitleLabel.textColor = UIColor(hex: "4A2511")
        transcribedTextContainer.addSubview(transcribedTextTitleLabel)
        
        transcribedTextLabel.font = UIFont.systemFont(ofSize: 18)
        transcribedTextLabel.textColor = UIColor(hex: "4A2511")
        transcribedTextLabel.numberOfLines = 0
        transcribedTextLabel.textAlignment = .center
        transcribedTextLabel.text = ""
        transcribedTextContainer.addSubview(transcribedTextLabel)
        
        // Accuracy display
        accuracyLabel.text = "Accuracy: 0%"
        accuracyLabel.font = UIFont.boldSystemFont(ofSize: 16)
        accuracyLabel.textColor = UIColor(hex: "4A2511")
        accuracyLabel.textAlignment = .center
        view.addSubview(accuracyLabel)
        
        accuracyProgressView.progressTintColor = UIColor(hex: "4CAF50")
        accuracyProgressView.trackTintColor = UIColor(hex: "E0E0E0")
        accuracyProgressView.layer.cornerRadius = 5
        accuracyProgressView.clipsToBounds = true
        view.addSubview(accuracyProgressView)
        
        // Record button
        recordButton.backgroundColor = UIColor(hex: "B33B1C")
        recordButton.setTitle("🎤 Start Recording", for: .normal)
        recordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        recordButton.setTitleColor(.white, for: .normal)
        recordButton.layer.cornerRadius = 25
        recordButton.layer.borderWidth = 1
        recordButton.layer.borderColor = UIColor(hex: "4A2511").cgColor
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        view.addSubview(recordButton)
        
        // Button stack
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 10
        view.addSubview(buttonStack)
        
        // Retry button
        retryButton.backgroundColor = UIColor(hex: "F7C6C7")
        retryButton.setTitle("🔄 Retry", for: .normal)
        retryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.layer.cornerRadius = 20
        retryButton.layer.borderWidth = 1
        retryButton.layer.borderColor = UIColor(hex: "4A2511").cgColor
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        retryButton.isEnabled = false
        buttonStack.addArrangedSubview(retryButton)
        
        // New text button
        newTextButton.backgroundColor = UIColor(hex: "A8D5BA")
        newTextButton.setTitle("📝 New Sentence", for: .normal)
        newTextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        newTextButton.setTitleColor(.white, for: .normal)
        newTextButton.layer.cornerRadius = 20
        newTextButton.layer.borderWidth = 1
        newTextButton.layer.borderColor = UIColor(hex: "4A2511").cgColor
        newTextButton.addTarget(self, action: #selector(newTextButtonTapped), for: .touchUpInside)
        buttonStack.addArrangedSubview(newTextButton)
        
        // Feedback label
        feedbackLabel.font = UIFont.systemFont(ofSize: 16)
        feedbackLabel.textColor = UIColor(hex: "4A2511")
        feedbackLabel.numberOfLines = 0
        feedbackLabel.textAlignment = .center
        feedbackLabel.backgroundColor = UIColor(hex: "F0F8FF")
        feedbackLabel.layer.cornerRadius = 10
        feedbackLabel.layer.masksToBounds = true
        view.addSubview(feedbackLabel)
        
        // Set up constraints
        setupConstraints(
            logoView: logoView,
            titleLabel: titleLabel,
            targetTextContainer: targetTextContainer,
            targetTextTitleLabel: targetTextTitleLabel,
            transcribedTextContainer: transcribedTextContainer,
            transcribedTextTitleLabel: transcribedTextTitleLabel,
            buttonStack: buttonStack
        )
    }
    
    private func setupConstraints(
        logoView: UIView,
        titleLabel: UILabel,
        targetTextContainer: UIView,
        targetTextTitleLabel: UILabel,
        transcribedTextContainer: UIView,
        transcribedTextTitleLabel: UILabel,
        buttonStack: UIStackView
    ) {
        // Make all views use autolayout
        [logoView, titleLabel, difficultySegmentedControl, targetTextContainer, targetTextTitleLabel, targetTextLabel,
         transcribedTextContainer, transcribedTextTitleLabel, transcribedTextLabel, accuracyLabel, accuracyProgressView,
         recordButton, buttonStack, feedbackLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Title label
            titleLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Difficulty selector
            difficultySegmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            difficultySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            difficultySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            difficultySegmentedControl.heightAnchor.constraint(equalToConstant: 32),
            
            // Target text container
            targetTextContainer.topAnchor.constraint(equalTo: difficultySegmentedControl.bottomAnchor, constant: 20),
            targetTextContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            targetTextContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            targetTextContainer.heightAnchor.constraint(equalToConstant: 100),
            
            targetTextTitleLabel.topAnchor.constraint(equalTo: targetTextContainer.topAnchor, constant: 15),
            targetTextTitleLabel.leadingAnchor.constraint(equalTo: targetTextContainer.leadingAnchor, constant: 15),
            
            targetTextLabel.topAnchor.constraint(equalTo: targetTextTitleLabel.bottomAnchor, constant: 10),
            targetTextLabel.leadingAnchor.constraint(equalTo: targetTextContainer.leadingAnchor, constant: 15),
            targetTextLabel.trailingAnchor.constraint(equalTo: targetTextContainer.trailingAnchor, constant: -15),
            targetTextLabel.bottomAnchor.constraint(equalTo: targetTextContainer.bottomAnchor, constant: -15),
            
            // Transcribed text container
            transcribedTextContainer.topAnchor.constraint(equalTo: targetTextContainer.bottomAnchor, constant: 15),
            transcribedTextContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            transcribedTextContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            transcribedTextContainer.heightAnchor.constraint(equalToConstant: 100),
            
            transcribedTextTitleLabel.topAnchor.constraint(equalTo: transcribedTextContainer.topAnchor, constant: 15),
            transcribedTextTitleLabel.leadingAnchor.constraint(equalTo: transcribedTextContainer.leadingAnchor, constant: 15),
            
            transcribedTextLabel.topAnchor.constraint(equalTo: transcribedTextTitleLabel.bottomAnchor, constant: 10),
            transcribedTextLabel.leadingAnchor.constraint(equalTo: transcribedTextContainer.leadingAnchor, constant: 15),
            transcribedTextLabel.trailingAnchor.constraint(equalTo: transcribedTextContainer.trailingAnchor, constant: -15),
            transcribedTextLabel.bottomAnchor.constraint(equalTo: transcribedTextContainer.bottomAnchor, constant: -15),
            
            // Accuracy display
            accuracyLabel.topAnchor.constraint(equalTo: transcribedTextContainer.bottomAnchor, constant: 15),
            accuracyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            accuracyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            accuracyProgressView.topAnchor.constraint(equalTo: accuracyLabel.bottomAnchor, constant: 10),
            accuracyProgressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            accuracyProgressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            accuracyProgressView.heightAnchor.constraint(equalToConstant: 10),
            
            // Record button
            recordButton.topAnchor.constraint(equalTo: accuracyProgressView.bottomAnchor, constant: 20),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.widthAnchor.constraint(equalToConstant: 200),
            recordButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Button stack
            buttonStack.topAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: 15),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStack.heightAnchor.constraint(equalToConstant: 40),
            
            // Feedback label
            feedbackLabel.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 15),
            feedbackLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            feedbackLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            feedbackLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            feedbackLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
        ])
    }
    
    private func setupPronunciationService() {
        pronunciationService.delegate = self
    }
    
    @objc private func difficultyChanged() {
        loadNewText()
    }
    
    @objc private func recordButtonTapped() {
        guard let currentText = currentText else { return }
        
        if pronunciationService.isRecording {
            pronunciationService.stopRecording()
            recordButton.setTitle("🎤 Record", for: .normal)
            recordButton.backgroundColor = UIColor(hex: "B33B1C")
        } else {
            pronunciationService.startRecording(targetText: currentText.text)
            recordButton.setTitle("⏹️ Stop Recoding", for: .normal)
            recordButton.backgroundColor = UIColor.red
            transcribedTextLabel.text = "Recording ..."
            feedbackLabel.text = ""
            resetAccuracy()
        }
    }
    
    @objc private func retryButtonTapped() {
        transcribedTextLabel.text = ""
        feedbackLabel.text = ""
        resetAccuracy()
        retryButton.isEnabled = false
    }
    
    @objc private func newTextButtonTapped() {
        loadNewText()
        transcribedTextLabel.text = ""
        feedbackLabel.text = ""
        resetAccuracy()
        retryButton.isEnabled = false
    }
    
    private func loadNewText() {
        let selectedDifficulty: PronunciationDifficulty
        
        switch difficultySegmentedControl.selectedSegmentIndex {
        case 0:
            selectedDifficulty = .easy
        case 1:
            selectedDifficulty = .medium
        case 2:
            selectedDifficulty = .hard
        default:
            selectedDifficulty = .easy
        }
        
        currentText = PronunciationDataManager.shared.getRandomText(difficulty: selectedDifficulty)
        targetTextLabel.text = currentText?.text
    }
    
    private func resetAccuracy() {
        accuracyLabel.text = "Accuracy: 0%"
        accuracyProgressView.progress = 0.0
    }
    
    private func updateAccuracy(_ accuracy: Double) {
        let percentage = Int(accuracy * 100)
        accuracyLabel.text = "Accuracy: \(percentage)%"
        accuracyProgressView.setProgress(Float(accuracy), animated: true)
        
        // Change progress color based on accuracy
        switch percentage {
        case 80...100:
            accuracyProgressView.progressTintColor = UIColor(hex: "4CAF50")
        case 60..<80:
            accuracyProgressView.progressTintColor = UIColor(hex: "FF9800")
        default:
            accuracyProgressView.progressTintColor = UIColor(hex: "F44336")
        }
    }
}

// MARK: - PronunciationServiceDelegate
extension PronunciationViewController: PronunciationServiceDelegate {
    func pronunciationServiceDidUpdateTranscription(_ text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.transcribedTextLabel.text = text
        }
    }
    
    func pronunciationServiceDidFinishRecording(success: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.recordButton.setTitle("🎤 Record", for: .normal)
            self?.recordButton.backgroundColor = UIColor(hex: "B33B1C")
            self?.retryButton.isEnabled = true
            
            if !success {
                self?.transcribedTextLabel.text = "Recording failed. Please try again."
            }
        }
    }
    
    func pronunciationServiceDidCompareTexts(similarity: Double, feedback: String) {
        DispatchQueue.main.async { [weak self] in
            self?.updateAccuracy(similarity)
            self?.feedbackLabel.text = feedback
        }
    }
}

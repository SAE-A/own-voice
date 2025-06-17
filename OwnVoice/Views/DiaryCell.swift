//
//  DiaryCell.swift
//  OwnVoice
//
//  Created by me on 2025/06/13.
//

import Foundation
import UIKit

class DiaryCell: UITableViewCell {
    
    private let noteView = UIView()
    private let diaryTextLabel = UILabel()
    private let timeLabel = UILabel()
    private let iconLabel = UILabel()
    private let paperclipImageView = UIImageView()
    private let deleteButton = UIButton()
    
    let emojis = ["💖", "💎", "😊", "🎵", "🔥", "🌟", "🎀", "🌹", "🐱", "🍎"]
    
    // Closure for delete action
    var deleteAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        // Note view
        noteView.backgroundColor = UIColor(hex: "FFC0CB").withAlphaComponent(0.5)
        noteView.layer.cornerRadius = 10
        noteView.layer.shadowColor = UIColor.black.cgColor
        noteView.layer.shadowOpacity = 0.1
        noteView.layer.shadowOffset = CGSize(width: 0, height: 2)
        noteView.layer.shadowRadius = 5
        contentView.addSubview(noteView)
        
        // Text label
        diaryTextLabel.font = UIFont.systemFont(ofSize: 16)
        diaryTextLabel.textColor = UIColor(hex: "4A2511")
        diaryTextLabel.numberOfLines = 0
        noteView.addSubview(diaryTextLabel)
        
        // Time label
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = UIColor(hex: "4A2511").withAlphaComponent(0.7)
        timeLabel.textAlignment = .right
        noteView.addSubview(timeLabel)
        
        // Icon label
        iconLabel.font = UIFont.systemFont(ofSize: 20)
        iconLabel.textAlignment = .left
        noteView.addSubview(iconLabel)
        
        // Paperclip image
        paperclipImageView.image = UIImage(systemName: "paperclip")
        paperclipImageView.tintColor = .gray
        noteView.addSubview(paperclipImageView)
        
        // Delete button
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = UIColor(hex: "B33B1C")
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        noteView.addSubview(deleteButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        noteView.translatesAutoresizingMaskIntoConstraints = false
        diaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        paperclipImageView.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            noteView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            noteView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            noteView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            paperclipImageView.topAnchor.constraint(equalTo: noteView.topAnchor, constant: 15),
            paperclipImageView.trailingAnchor.constraint(equalTo: noteView.trailingAnchor, constant: -15),
            paperclipImageView.widthAnchor.constraint(equalToConstant: 20),
            paperclipImageView.heightAnchor.constraint(equalToConstant: 20),
            
            diaryTextLabel.topAnchor.constraint(equalTo: noteView.topAnchor, constant: 15),
            diaryTextLabel.leadingAnchor.constraint(equalTo: noteView.leadingAnchor, constant: 15),
            diaryTextLabel.trailingAnchor.constraint(equalTo: noteView.trailingAnchor, constant: -15),
            
            timeLabel.topAnchor.constraint(equalTo: diaryTextLabel.bottomAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: noteView.trailingAnchor, constant: -15),
            
            iconLabel.topAnchor.constraint(equalTo: diaryTextLabel.bottomAnchor, constant: 10),
            iconLabel.leadingAnchor.constraint(equalTo: noteView.leadingAnchor, constant: 15),
            iconLabel.bottomAnchor.constraint(equalTo: noteView.bottomAnchor, constant: -15),
            
            deleteButton.centerYAnchor.constraint(equalTo: iconLabel.centerYAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 15),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc private func deleteButtonTapped() {
        deleteAction?()
    }
    
    func configure(with recording: Recording, timeString: String) {
        diaryTextLabel.text = recording.text
        timeLabel.text = timeString
        
        let randomIcon = emojis.randomElement() ?? "🍀"
        iconLabel.text = randomIcon
    }
}

//
//  DiaryViewController.swift
//  OwnVoice
//
//  Created by me on 2025/06/13.
//

import Foundation
import UIKit

class DiaryViewController: UIViewController {
    
    // UI Elements
    private let tableView = UITableView()
    
    // Data
    private var recordings: [Recording] = []
    private var groupedRecordings: [String: [Recording]] = [:]
    private var sortedDates: [String] = []
    
    // Date formatters
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reload recordings when view appears
        loadRecordings()
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
        
        // Table view setup
        tableView.register(DiaryCell.self, forCellReuseIdentifier: "DiaryCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        
        // Set up constraints
        setupConstraints()
    }
    
    private func setupConstraints() {
        // Make all views use autolayout
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Table view constraints
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadRecordings() {
        recordings = RecordingStorage.loadRecordings()
        
        // Group recordings by date
        groupedRecordings = Dictionary(grouping: recordings) { recording in
            return dateFormatter.string(from: recording.date)
        }
        
        // Sort dates in descending order
        sortedDates = groupedRecordings.keys.sorted(by: >)
        
        tableView.reloadData()
    }
    
    // Delete recording
    func deleteRecording(at indexPath: IndexPath) {
        let date = sortedDates[indexPath.section]
        guard var dateRecordings = groupedRecordings[date], indexPath.row < dateRecordings.count else {
            return
        }
        
        // Get the recording to delete
        let recordingToDelete = dateRecordings[indexPath.row]
        
        // Remove from the current section
        dateRecordings.remove(at: indexPath.row)
        
        // Update the grouped recordings
        if dateRecordings.isEmpty {
            groupedRecordings.removeValue(forKey: date)
            sortedDates.remove(at: indexPath.section)
        } else {
            groupedRecordings[date] = dateRecordings
        }
        
        // Remove from the main recordings array
        if let index = recordings.firstIndex(where: { $0.id == recordingToDelete.id }) {
            recordings.remove(at: index)
        }
        
        // Save the updated recordings
        RecordingStorage.saveRecordings(recordings)
        
        // Update the table view
        if dateRecordings.isEmpty {
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
        } else {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DiaryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = sortedDates[section]
        return groupedRecordings[date]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as! DiaryCell
        
        let date = sortedDates[indexPath.section]
        if let recordings = groupedRecordings[date], indexPath.row < recordings.count {
            let recording = recordings[indexPath.row]
            
            // Get time string
            let timeString = timeFormatter.string(from: recording.date)
            
            cell.configure(with: recording, timeString: timeString)
            
            // Set delete button action
            cell.deleteAction = { [weak self] in
                self?.deleteRecording(at: indexPath)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedDates[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

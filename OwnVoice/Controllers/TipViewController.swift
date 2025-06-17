//
//  TipViewController.swift
//  OwnVoice
//
//  Created by me on 2025/06/13.
//

import Foundation
import UIKit

class TipViewController: UIViewController {
    
    // MARK: - Properties
    
    // 탭별 콘텐츠 데이터
    private let tabContents: [[(String, String)]] = [
        [
            ("1. 복식 호흡", "배에 힘을 주고 아랫배를 팽창시키면서\n숨을 들이쉬는 방법입니다.\n숨을 깊게 들이쉬고, 촛불을 끄듯이 천천히\n뱉어내면서 소리를 내는 연습을 합니다."),
            ("2. 목에 힘 빼기", "목을 쉬어쟀거나 힘을 주지 않고\n편안하게 이완시킨 상태에서\n발성해야 합니다.\n하품이나 한숨을 쉬는 것처럼\n목을 이완시키는 상태에서\n발성 연습을 하면 좋습니다."),
            ("3. 자세 교정", "척추를 똑바로 세우고 어깨를 편안하게 한 채 서거나 앉으세요.\n머리를 수평으로 유지하고 턱을 바닥과 평행하게 유지하세요.\n가슴은 활짝 열고 눌리지 않도록 하세요.\n좋은 자세는 올바른 호흡과 발성을 도와줍니다.")
        ],
        [
            ("1. 발음 연습", "정확한 발음을 위해 입 모양을 크게 하고\n천천히 발음하는 연습을 합니다.\n거울을 보면서 입 모양을 확인하며\n연습하면 더욱 효과적입니다."),
            ("2. 속도 조절", "너무 빠르게 말하면 발음이 부정확해집니다.\n천천히 또박또박 말하는 연습을 통해\n명확한 발음을 만들어갑니다."),
            ("3. 억양 패턴", "올라갔다 내려가는 음의 패턴을 연습해 보세요.\n중요한 단어에는 적절한 강세를 주세요.\n청취자가 지루하지 않도록 톤을 다양하게 바꿔 보세요.\n질문과 평서문의 억양 차이도 연습해 보세요.")
        ],
        [
            ("1. 음식 선택", "목소리에 좋은 음식으로는 꿀, 생강차,\n따뜻한 물, 사과 등이 있습니다.\n카페인이나 알코올, 매운 음식은\n목에 자극을 줄 수 있으니 피하는 것이 좋습니다."),
            ("2. 수분 섭취", "충분한 수분 섭취는 성대를 촉촉하게 유지하는데\n도움이 됩니다. 하루에 최소 8잔의 물을\n마시는 것을 권장합니다."),
            ("3. 목소리 휴식과 회복", "목소리를 많이 쓸 때는 규칙적으로 휴식을 주세요.\n속삭임은 정상적인 말보다 성대를 더 무리하게 하니 피하세요.\n충분한 수면으로 성대가 회복할 시간을 주세요.\n부드러운 허밍 연습으로 목소리를 예열하세요.")
        ]
    ]
    
    private var tabContentViews: [UIView] = []
    private var currentTabIndex: Int = 0
    
    // UI
    private let titleLabel = UILabel()
    private let contentView = UIView()
    private let tabContainer = UIView()
    private var tabButtons: [UIButton] = []
    private let notebookView = UIView()
    private let headerLineView = UIView()
    
    // 로고뷰
    private let logoView = LogoView()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLogoView()
        setupNotebookView()
        setupHeaderLine()
        setupTabContainer()
        setupTitleLabel()
        setupContentView()
        setupTabContentViews()
        
        updateContent(for: 0)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - UI Setup
    
    private func setupLogoView() {
        view.addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -40),
            logoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -70),
            logoView.widthAnchor.constraint(equalToConstant: 240),
            logoView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    private func setupNotebookView() {
        notebookView.backgroundColor = .white
        notebookView.layer.cornerRadius = 20
        notebookView.layer.shadowColor = UIColor.black.cgColor
        notebookView.layer.shadowOpacity = 0.2
        notebookView.layer.shadowOffset = CGSize(width: 0, height: 2)
        notebookView.layer.shadowRadius = 5
        notebookView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        notebookView.layer.borderWidth = 1
        view.addSubview(notebookView)
        
        notebookView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            notebookView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: -20),
            notebookView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notebookView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            notebookView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupHeaderLine() {
        // 메인 헤더 라인
        headerLineView.backgroundColor = UIColor(hex: "4A2511").withAlphaComponent(0.3)
        headerLineView.layer.cornerRadius = 2
        notebookView.addSubview(headerLineView)
        
        // 작은 장식 라인들
        let accentLine1 = UIView()
        accentLine1.backgroundColor = UIColor(hex: "FFC0CB")
        accentLine1.layer.cornerRadius = 1
        notebookView.addSubview(accentLine1)
        
        let accentLine2 = UIView()
        accentLine2.backgroundColor = UIColor(hex: "FFC0CB")
        accentLine2.layer.cornerRadius = 1
        notebookView.addSubview(accentLine2)
        
        let accentLine3 = UIView()
        accentLine3.backgroundColor = UIColor(hex: "FFC0CB")
        accentLine3.layer.cornerRadius = 1
        notebookView.addSubview(accentLine3)
        
        // 제약 조건 설정
        [headerLineView, accentLine1, accentLine2, accentLine3].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 메인 헤더 라인
            headerLineView.topAnchor.constraint(equalTo: notebookView.topAnchor, constant: 15),
            headerLineView.leadingAnchor.constraint(equalTo: notebookView.leadingAnchor, constant: 20),
            headerLineView.trailingAnchor.constraint(equalTo: notebookView.trailingAnchor, constant: -20),
            headerLineView.heightAnchor.constraint(equalToConstant: 4),
            
            // 장식 라인들
            accentLine1.topAnchor.constraint(equalTo: headerLineView.bottomAnchor, constant: 3),
            accentLine1.leadingAnchor.constraint(equalTo: notebookView.leadingAnchor, constant: 25),
            accentLine1.widthAnchor.constraint(equalToConstant: 60),
            accentLine1.heightAnchor.constraint(equalToConstant: 2),
            
            accentLine2.topAnchor.constraint(equalTo: headerLineView.bottomAnchor, constant: 3),
            accentLine2.centerXAnchor.constraint(equalTo: notebookView.centerXAnchor),
            accentLine2.widthAnchor.constraint(equalToConstant: 60),
            accentLine2.heightAnchor.constraint(equalToConstant: 2),
            
            accentLine3.topAnchor.constraint(equalTo: headerLineView.bottomAnchor, constant: 3),
            accentLine3.trailingAnchor.constraint(equalTo: notebookView.trailingAnchor, constant: -25),
            accentLine3.widthAnchor.constraint(equalToConstant: 60),
            accentLine3.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func setupTabContainer() {
        tabContainer.backgroundColor = UIColor(hex: "F5F5F5")
        tabContainer.layer.cornerRadius = 10
        notebookView.addSubview(tabContainer)
        
        tabContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabContainer.topAnchor.constraint(equalTo: headerLineView.bottomAnchor, constant: 25),
            tabContainer.leadingAnchor.constraint(equalTo: notebookView.leadingAnchor, constant: 20),
            tabContainer.trailingAnchor.constraint(equalTo: notebookView.trailingAnchor, constant: -20),
            tabContainer.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let tabTitles = ["Voice", "Speaking", "Care"]
        let tabColors = [UIColor(hex: "FFC0CB"), UIColor(hex: "FFC0CB"), UIColor(hex: "FFC0CB")]
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        tabContainer.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: tabContainer.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: tabContainer.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: tabContainer.trailingAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: tabContainer.bottomAnchor, constant: -5)
        ])
        
        for i in 0..<tabTitles.count {
            let button = UIButton(type: .system)
            button.setTitle(tabTitles[i], for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.backgroundColor = i == 0 ? tabColors[i] : .white
            button.setTitleColor(UIColor(hex: "4A2511"), for: .normal)
            button.layer.cornerRadius = 8
            button.tag = i
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
            tabButtons.append(button)
        }
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = UIColor(hex: "4A2511")
        titleLabel.textAlignment = .left
        notebookView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: tabContainer.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: notebookView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: notebookView.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupContentView() {
        contentView.backgroundColor = .clear
        notebookView.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: notebookView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: notebookView.trailingAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: notebookView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupTabContentViews() {
        for tabIndex in 0..<tabContents.count {
            let tabView = createContentView(for: tabIndex)
            tabView.isHidden = true
            contentView.addSubview(tabView)
            tabContentViews.append(tabView)
            
            NSLayoutConstraint.activate([
                tabView.topAnchor.constraint(equalTo: contentView.topAnchor),
                tabView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                tabView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                tabView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
    }
    
    // MARK: - 탭 변경 액션
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        updateContent(for: sender.tag)
        updateTabButtonAppearance(selectedIndex: sender.tag)
    }
    
    private func updateTabButtonAppearance(selectedIndex: Int) {
        let tabColors = [UIColor(hex: "FFC0CB"), UIColor(hex: "FFC0CB"), UIColor(hex: "FFC0CB")]
        
        for (index, button) in tabButtons.enumerated() {
            if index == selectedIndex {
                button.backgroundColor = tabColors[index]
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            } else {
                button.backgroundColor = .white
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            }
        }
    }
    
    // MARK: - 콘텐츠 생성 및 업데이트
    
    private func createContentView(for tabIndex: Int) -> UIView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = true // 스크롤 바운스 효과 추가
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            container.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ])
        
        for (title, content) in tabContents[tabIndex] {
            let sectionView = createSectionView(title: title, content: content)
            stack.addArrangedSubview(sectionView)
        }
        
        return scrollView
    }
    
    private func createSectionView(title: String, content: String) -> UIView {
        let sectionView = UIView()
        sectionView.backgroundColor = UIColor(hex: "FFFFFF")
        sectionView.layer.cornerRadius = 10
        sectionView.layer.shadowColor = UIColor.black.cgColor
        sectionView.layer.shadowOpacity = 0.1
        sectionView.layer.shadowOffset = CGSize(width: 0, height: 1)
        sectionView.layer.shadowRadius = 3
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor(hex: "4A2511")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let contentLabel = UILabel()
        contentLabel.text = content
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.textColor = UIColor(hex: "4A2511")
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        sectionView.addSubview(titleLabel)
        sectionView.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -15),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            contentLabel.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 15),
            contentLabel.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -15),
            contentLabel.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor, constant: -12)
        ])
        
        return sectionView
    }
    
    func updateContent(for tabIndex: Int) {
        switch tabIndex {
        case 0:
            titleLabel.text = "Proper Voice Techniques"
        case 1:
            titleLabel.text = "Speaking Skills"
        case 2:
            titleLabel.text = "Voice Care & Diet"
        default:
            titleLabel.text = ""
        }
        
        for (i, tabView) in tabContentViews.enumerated() {
            tabView.isHidden = (i != tabIndex)
        }
        
        currentTabIndex = tabIndex
    }
}

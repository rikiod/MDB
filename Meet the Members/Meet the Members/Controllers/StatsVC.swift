//
//  StatsVC.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import UIKit

class StatsVC: UIViewController {
    
    // MARK: STEP 11: Going to StatsVC
    // Read the instructions in MainVC.swift
    
    let dataExample: String
    let statsStreak: Int
    let statslastThree: [String]
    
    
    
    init(data: String, lastThree: [String], streak: Int) {
        self.dataExample = data
        self.statsStreak = streak
        self.statslastThree = lastThree
        // Delegate rest of the initialization to super class
        // designated initializer.
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: >> Your Code Here <<
    
    // MARK: STEP 12: StatsVC UI
    // Action Items:
    // - Initialize the UI components, add subviews and constraints
    let longestStreak: UILabel = {
        let longestStreak = UILabel()
        
        longestStreak.textColor = .darkGray
        longestStreak.textAlignment = .left
        longestStreak.font = .systemFont(ofSize: 27, weight: .medium)
        longestStreak.translatesAutoresizingMaskIntoConstraints = false
        
        return longestStreak
    }()
    
    let lastThree: UILabel = {
        let lastThree = UILabel()
        
        lastThree.textColor = .darkGray
        lastThree.textAlignment = .left
        lastThree.font = .systemFont(ofSize: 27, weight: .medium)
        lastThree.lineBreakMode = .byWordWrapping
        lastThree.numberOfLines = 0
        lastThree.translatesAutoresizingMaskIntoConstraints = false
        
        return lastThree
    }()
    
    let statisticsLabel: UILabel = {
        let label = UILabel()
        
        // == UIColor.darkGray
        label.textColor = .systemGreen
        label.text = "Statistics"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 27, weight: .medium)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        return label
    }()
    
    // MARK: >> Your Code Here <<
    let backButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: >> Your Code Here <<
        view.backgroundColor = .white
        longestStreak.text = "Your longest streak is \(statsStreak)."
        if statslastThree[0] != "" {
            lastThree.text = "Your results for the last three people has been \(statslastThree[0]) \(statslastThree[1]) \(statslastThree[2])."
        }

        
        view.addSubview(backButton)
        view.addSubview(longestStreak)
        view.addSubview(lastThree)
        view.addSubview(statisticsLabel)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 700),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            longestStreak.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            longestStreak.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            longestStreak.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            lastThree.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 350),
            lastThree.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            lastThree.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            statisticsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            statisticsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            statisticsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        

    }
    
    @objc func didTapBack(_ sender:UIButton) {
        let vc = MainVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

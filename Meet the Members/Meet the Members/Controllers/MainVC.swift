//
//  MainVC.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    
    var score = 0
    var runCount = 0
    var answer: String?
    var hasbeenselected = false
    var pressed = 0
    var storedbutton = 0
    var mainStreak = 0
    var lastThree = ["", "", ""]
    var counter = 0
    // Create a property for our timer, we will initialize it in viewDidLoad
    var timer: Timer?
    
    // MARK: STEP 7: UI Customization
    // Action Items:
    // - Customize your imageView and buttons.
    let imageView: UIImageView = {
        let view = UIImageView()
        
        // MARK: >> Your Code Here <<
    
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let buttons: [UIButton] = {
        return (0..<4).map { index in
            let button = UIButton()

            // Tag the button its index
            button.tag = index
            
            // MARK: >> Your Code Here <<
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemBlue

            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }
        
    }()
    
    // MARK: STEP 10: Stats Button
    // Action Items:
    // - Follow the examples you've seen so far, create and
    // configure a UIButton for presenting the StatsVC. Only the
    // callback function `didTapStats(_:)` was written for you.
    
    // MARK: >> Your Code Here <<
    let statsButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Stats", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
    
        button.setImage(UIImage(systemName: "person.fill"), for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let pauseButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Pause", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        
        button.setImage(UIImage(systemName: "pause.fill"), for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        // Create a timer that calls timerCallback() every one second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        
        // MARK: STEP 6: Adding Subviews and Constraints
        // Action Items:
        // - Add imageViews and buttons to the root view.
        // - Create and activate the layout constraints.
        // - Run the App
        
        // Additional Information:
        // If you don't like the default presentation style,
        // you can change it to full screen too! However, in this
        // case you will have to find a way to manually to call
        // dismiss(animated: true, completion: nil) in order
        // to go back.
        //
        // modalPresentationStyle = .fullScreen
        
        // MARK: >> Your Code Here <<
        view.addSubview(imageView)
        view.addSubview(buttons[0])
        view.addSubview(buttons[1])
        view.addSubview(buttons[2])
        view.addSubview(buttons[3])
        view.addSubview(statsButton)
        view.addSubview(pauseButton)
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            imageView.heightAnchor.constraint(equalToConstant: 250), // edit this line to make the image more proportional 
            
            buttons[0].topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 500),
            buttons[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            buttons[0].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            buttons[1].topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 550),
            buttons[1].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            buttons[1].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            buttons[2].topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 600),
            buttons[2].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            buttons[2].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            buttons[3].topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 650),
            buttons[3].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            buttons[3].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            statsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            statsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            statsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            pauseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            pauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            pauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 700),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])

        
        getNextQuestion()
        
        // MARK: STEP 9: Bind Callbacks to the Buttons
        // Action Items:
        // - Bind the `didTapAnswer(_:)` function to the buttons.
        
        // MARK: >> Your Code Here <<
        buttons[0].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        buttons[1].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        buttons[2].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        buttons[3].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
            
        // MARK: STEP 10: Stats Button
        // See instructions above.

        // MARK: >> Your Code Here <<
        statsButton.addTarget(self, action: #selector(didTapStats(_:)), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(didTapPause(_:)), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBack(_:)), for: .touchUpInside)


    }
    
    // What's the difference between viewDidLoad() and
    // viewWillAppear()? What about viewDidAppear()?
    override func viewWillAppear(_ animated: Bool) {
        // MARK: STEP 13: Resume Game
        // Action Items:
        // - Reinstantiate timer when view appears
        
        // MARK: >> Your Code Here <<
    }
    
    func getNextQuestion() {
        // MARK: STEP 5: Data Model
        // Action Items:
        // - Get a question instance from `QuestionProvider`
        // - Configure the imageView and buttons with information from
        //   the question instance
        
        // MARK: >> Your Code Here <<
        let question = QuestionProvider.shared.nextQuestion()
        
        let image = question?.image
        let newAnswer = question?.answer
        let choices = question?.choices
        
        answer = newAnswer
        
        imageView.image = image
        buttons[0].setTitle(choices?[0], for: .normal)
        buttons[1].setTitle(choices?[1], for: .normal)
        buttons[2].setTitle(choices?[2], for: .normal)
        buttons[3].setTitle(choices?[3], for: .normal)
        
    }
    
    // MARK: STEP 8: Buttons and Timer Callback
    // Action Items:
    // - Complete the callback function for the 4 buttons.
    // - Complete the callback function for the timer instance
    //
    // Additional Information:
    // Take some time to plan what should be in here.
    // The 4 buttons should share the same callback.
    //
    // Add instance properties and/or methods
    // to the class if necessary. You may need to come back
    // to this step later on.
    //
    // Hint:
    // - The timer will fire every one second.
    // - You can use `sender.tag` to identify which button is pressed.
    

    @objc func timerCallback() {
        // MARK: >> Your Code Here <<
        runCount += 1
        for button in buttons {
            if (button.titleLabel!.text) == answer {
                storedbutton = button.tag
            }
        }
        if runCount >= 5 {
            buttons[storedbutton].backgroundColor = .systemGreen
            if runCount == 7 {
                runCount = 0
                buttons[0].backgroundColor = .systemBlue
                buttons[1].backgroundColor = .systemBlue
                buttons[2].backgroundColor = .systemBlue
                buttons[3].backgroundColor = .systemBlue
                getNextQuestion()
            }
        }
        if (hasbeenselected == true) {
            if runCount == 2 {
                buttons[pressed].backgroundColor = .systemBlue
                buttons[0].backgroundColor = .systemBlue
                buttons[1].backgroundColor = .systemBlue
                buttons[2].backgroundColor = .systemBlue
                buttons[3].backgroundColor = .systemBlue
                runCount = 0
                hasbeenselected = false
                getNextQuestion()
            }
        }
    }
    
    @objc func didTapAnswer(_ sender: UIButton) {
        // MARK: >> Your Code Here <<
        if hasbeenselected == false {
            pressed = sender.tag
            runCount = 0
            if counter == 3 {
                counter = 0
            }
            else if (buttons[sender.tag].titleLabel!.text) == answer {
                hasbeenselected = true
                mainStreak += 1
                lastThree[counter] = "correct"
                buttons[pressed].backgroundColor = .systemGreen
                }
            else {
                hasbeenselected = true
                mainStreak = 0
                lastThree[counter] = "false"
                buttons[pressed].backgroundColor = .systemRed
                buttons[storedbutton].backgroundColor = .systemGreen
            }
            counter += 1
        }
    }

    
    @objc func didTapStats(_ sender: UIButton) {
        
        let vc = StatsVC(data: "Hello", lastThree: lastThree, streak: mainStreak)
        
        vc.modalPresentationStyle = .fullScreen
    
        // MARK: STEP 11: Going to StatsVC
        // When we are navigating between VCs (e.g MainVC -> StatsVC),
        // we often need a mechanism for transferring data
        // between view controllers. There are many ways to achieve
        // this (initializer, delegate, notification center,
        // combined, etc.). We will start with the easiest one today,
        // which is custom initializer.
        //
        // Action Items:
        // - Pause the game when stats button is tapped
        // - Read the example in StatsVC.swift, and replace it with
        //   your custom init for `StatsVC`
        // - Update the call site here on line 139
        present(vc, animated: true, completion: nil)
    }
    
    
    @objc func didTapPause(_ sender:UIButton) {
        if pauseButton.titleLabel!.text == "Pause" {
            pauseButton.setTitle("Resume", for: .normal)
            pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timer?.invalidate()
        }
        else {
            pauseButton.setTitle("Pause", for: .normal)
            pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        }
    }
    
    
    @objc func didTapBack(_ sender:UIButton) {
        let vc = StartVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

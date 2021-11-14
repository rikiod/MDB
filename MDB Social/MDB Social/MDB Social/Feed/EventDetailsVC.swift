//
//  SignUpVC.swift
//  MDB Social
//
//  Created by Rikio Dahlgren on 11/14/21.
//

import UIKit
import FirebaseStorage

class EventDetailsVC: UIViewController {

    let event: SOCEvent?
        
    init(data: SOCEvent) {
        self.event = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let eventLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Event Name"
        lbl.textColor = .primaryText
        lbl.font = .systemFont(ofSize: 30, weight: .semibold)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let eventTimestampLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Timestamp"
        lbl.textColor = .secondaryText
        lbl.font = .systemFont(ofSize: 17, weight: .medium)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let eventDescriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Event Description"
        lbl.textColor = .secondaryText
        lbl.font = .systemFont(ofSize: 15, weight: .medium)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let backButton: UIButton = {
        let btn = UIButton()
        btn.layer.backgroundColor = UIColor.primary.cgColor
        btn.setTitle("Back", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.isUserInteractionEnabled = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let rsvpButton: LoadingButton = {
        let btn = LoadingButton()
        btn.layer.backgroundColor = UIColor.primary.cgColor
        btn.setTitle("RSVP", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.isUserInteractionEnabled = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let contentEdgeInset = UIEdgeInsets(top: 30, left: 40, bottom: 30, right: 40)
    
    private let buttonHeight: CGFloat = 44.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        view.addSubview(eventLabel)
        view.addSubview(eventTimestampLabel)
        view.addSubview(eventDescriptionLabel)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            eventLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: contentEdgeInset.top),
            eventLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: contentEdgeInset.left),
            eventLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: contentEdgeInset.right),
            
            eventTimestampLabel.topAnchor.constraint(equalTo: eventLabel.bottomAnchor, constant: 3),
            eventTimestampLabel.leadingAnchor.constraint(equalTo: eventLabel.leadingAnchor),
            eventTimestampLabel.trailingAnchor.constraint(equalTo: eventLabel.trailingAnchor),
            
            eventDescriptionLabel.topAnchor.constraint(equalTo: eventTimestampLabel.bottomAnchor, constant: 18),
            eventDescriptionLabel.leadingAnchor.constraint(equalTo: eventLabel.leadingAnchor),
            eventDescriptionLabel.trailingAnchor.constraint(equalTo: eventLabel.trailingAnchor),
            eventDescriptionLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.9),
            
            imageView.topAnchor.constraint(equalTo: eventDescriptionLabel.bottomAnchor, constant: 5),
            imageView.leadingAnchor.constraint(equalTo: eventLabel.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: eventLabel.trailingAnchor),
            imageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.9),

        ])
        
        eventLabel.text = event!.name
    
        let date = event!.startTimeStamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        eventTimestampLabel.text = dateFormatter.string(from: date)
        
        eventDescriptionLabel.text = event!.description
        
        let storage = Storage.storage()
        let imageRef: StorageReference = storage.reference(forURL: event!.photoURL)
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error: \(error)")
              } else {
                self.imageView.image = UIImage(data: data!)
              }
        }
        
        view.addSubview(backButton)
        view.addSubview(rsvpButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: contentEdgeInset.left),
            backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -contentEdgeInset.bottom),
            backButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -10),
            backButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            rsvpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -contentEdgeInset.right),
            rsvpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -contentEdgeInset.bottom),
            rsvpButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 10),
            rsvpButton.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
        
        backButton.layer.cornerRadius = buttonHeight / 2
        rsvpButton.layer.cornerRadius = buttonHeight / 2
        
        backButton.addTarget(self, action: #selector(didTapBack(_:)), for: .touchUpInside)
        rsvpButton.addTarget(self, action: #selector(didTapRSVP(_:)), for: .touchUpInside)
    }
    
    @objc func didTapBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapRSVP(_ sender: UIButton) {
        
        
    }
    

    
}



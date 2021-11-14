//
//  FeedVC.swift
//  MDB Social No Starter
//
//  Created by Michael Lin on 10/17/21.
//

import UIKit

class FeedVC: UIViewController {
    
    var events: [SOCEvent]?
    
    private let signOutButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .primary
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .medium))
        btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 25
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "MDB Socials"
        lbl.textColor = .primaryText
        lbl.font = .systemFont(ofSize: 30, weight: .semibold)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: EventCell.reuseIdentifier)
        
        return collectionView
    }()
    
    private let createEventButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .primary
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .medium))
        btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 25
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let contentEdgeInset = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background

        events = SOCDatabaseRequest.shared.getEvents(vc: self)
        view.addSubview(signOutButton)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(createEventButton)
        
        signOutButton.addTarget(self, action: #selector(didTapSignOut(_:)), for: .touchUpInside)
        createEventButton.addTarget(self, action: #selector(didTapCreateEvent(_:)), for: .touchUpInside)

        
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 140, left: 10, bottom: 110, right: 10))
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: contentEdgeInset.top),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: contentEdgeInset.left),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: contentEdgeInset.right),
            
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -contentEdgeInset.bottom),
            signOutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 10),
            signOutButton.widthAnchor.constraint(equalToConstant: 50),
            signOutButton.heightAnchor.constraint(equalTo: signOutButton.widthAnchor),
            
            createEventButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -contentEdgeInset.bottom),
            createEventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -10),
            createEventButton.widthAnchor.constraint(equalToConstant: 50),
            createEventButton.heightAnchor.constraint(equalTo: createEventButton.widthAnchor)
    
        ])
    }
    
    func updateEvents(newEvents: [SOCEvent]) {
            events = newEvents
            collectionView.reloadData()
    }
    
    @objc func didTapSignOut(_ sender: UIButton) {
        SOCAuthManager.shared.signOut {
            guard let window = UIApplication.shared
                    .windows.filter({ $0.isKeyWindow }).first else { return }
            let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController()
            window.rootViewController = vc
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.3
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
        }
    }
    
    @objc func didTapCreateEvent(_ sender: UIButton) {
        let vc = CreateEventVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension FeedVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = events?[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.reuseIdentifier, for: indexPath) as! EventCell
        cell.event = event
        return cell
    }
}

extension FeedVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * (4/5), height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at: indexPath) as! EventCell
        let vc = EventDetailsVC(data: tappedCell.event!)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
}

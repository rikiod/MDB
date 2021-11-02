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
        collectionView.register(CellVC.self, forCellWithReuseIdentifier: CellVC.reuseIdentifier)
        
        return collectionView
    }()
    
    private let contentEdgeInset = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
    
    override func viewDidLoad() {
        events = SOCDatabaseRequest.shared.getEvents(vc: self)
        view.addSubview(signOutButton)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        signOutButton.addTarget(self, action: #selector(didTapSignOut(_:)), for: .touchUpInside)
        
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 120, left: 10, bottom: 90, right: 10))
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
            signOutButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            signOutButton.widthAnchor.constraint(equalToConstant: 50),
            signOutButton.heightAnchor.constraint(equalTo: signOutButton.widthAnchor)
    
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
}

extension FeedVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = events?[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellVC.reuseIdentifier, for: indexPath) as! CellVC
        cell.event = event
        return cell
    }
}

extension FeedVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * (4/5), height: 160)
    }
    
}

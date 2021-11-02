//
//  CellVC.swift
//  MDB Social
//
//  Created by Rikio Dahlgren on 10/31/21.
//

import UIKit
import FirebaseStorage

class CellVC: UICollectionViewCell {
    
    static let reuseIdentifier: String = String(describing: CellVC.self)
    
    private var rsvpNames: [String] = []
    
    let storage = Storage.storage()
            
    var event: SOCEvent? {
        didSet {
            let imageRef: StorageReference = storage.reference(forURL: event!.photoURL)
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error: \(error)")
                  } else {
                    self.imageView.image = UIImage(data: data!)
                  }
            }
            
            nameView.text = event?.name
            rsvpView.text = "\(event?.rsvpUsers.count ?? 0) going"
            
            let authorRef = SOCDatabaseRequest.shared.db.collection("users").document(event!.creator)
            authorRef.getDocument(completion: { (querySnapshot, error) in
                if let error = error {
                    print("Error: \(error)")
                } else {
                    guard let user = try? querySnapshot?.data(as: SOCUser.self) else { return }
                    self.authorView.text = user.fullname
                }
            })
        }
    }
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let nameView: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .primaryText
        lbl.font = .systemFont(ofSize: 13, weight: .semibold)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let authorView: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .primaryText
        lbl.font = .systemFont(ofSize: 13, weight: .semibold)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let rsvpView: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .primaryText
        lbl.font = .systemFont(ofSize: 13, weight: .semibold)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        contentView.backgroundColor = .white
        
        contentView.addSubview(imageView)
        contentView.addSubview(authorView)
        contentView.addSubview(nameView)
        contentView.addSubview(rsvpView)
                
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameView.bottomAnchor.constraint(equalTo: authorView.topAnchor, constant: -10),
            nameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            authorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            authorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            rsvpView.topAnchor.constraint(equalTo: authorView.bottomAnchor, constant: 10),
            rsvpView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  PokeCell.swift
//  Pokedex
//
//  Created by Rikio Tsuyama-Dahlgren on 10/4/21.
//

import UIKit

class PokemonCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: PokemonCell.self)
    
    var pokemon: Pokemon? {
        didSet {
            let link = pokemon?.imageUrl
            let stringified = link?.absoluteString
            
            if stringified != nil {
                if let url: URL = URL(string: (stringified)!) {
                    if let data = try? Data(contentsOf: url) {
                            imageView.image = UIImage(data: data)
                        }
                }
            }
            
            let name: String = pokemon?.name ?? ""
            let id: Int = pokemon?.id ?? 0
            numberView.text = "\(id)"
            nameView.text = "\(name)"
        }
    }
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let numberView: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameView: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        contentView.backgroundColor = .white
        
        contentView.addSubview(imageView)
        contentView.addSubview(numberView)
        contentView.addSubview(nameView)
                
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 60),
    
            numberView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            numberView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            numberView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            nameView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

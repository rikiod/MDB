//
//  PokeDetailsVC.swift
//  Pokedex
//
//  Created by Rikio Dahlgren on 10/9/21.
//

import UIKit

class DetailsVC: UIViewController {
    
    let pokemon: Pokemon?
        
    init(data: Pokemon) {
        self.pokemon = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.textColor = .systemGreen
        titleLabel.backgroundColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 40)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }()
    
    let pokemonImage: UIImageView = {
        let pokemonImage = UIImageView()
        pokemonImage.contentMode = .scaleAspectFit
        pokemonImage.translatesAutoresizingMaskIntoConstraints = false
        return pokemonImage
    }()
    
    let detailLabels: [UILabel] = {
        return (0..<8).map { index in
            let detailLabel = UILabel()

            detailLabel.tag = index
            
            detailLabel.textColor = .systemGreen
            detailLabel.backgroundColor = .white
            detailLabel.textAlignment = .left
            detailLabel.font = .systemFont(ofSize: 20)
          
            detailLabel.translatesAutoresizingMaskIntoConstraints = false
            
            return detailLabel
        }
        
    }()
    
    private let mainViewStack: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 20
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    let returnButton: UIButton = {
        let returnButton = UIButton()
        
        returnButton.setTitle("Return", for: .normal)
        returnButton.setTitleColor(.white, for: .normal)
        returnButton.backgroundColor = .systemGreen
        returnButton.layer.cornerRadius = 10
        returnButton.addTarget(self, action: #selector(didTapReturn(_:)), for: .touchUpInside)
        
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        
        return returnButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        titleLabel.text = pokemon!.name + " Details"
        
        let link = pokemon!.imageUrl
        let stringified = link?.absoluteString
        
        if stringified != nil {
            if let url: URL = URL(string: (stringified)!) {
                    if let data = try? Data(contentsOf: url) {
                            pokemonImage.image = UIImage(data: data)
                        }
                }
        }
        
        detailLabels[0].text = "Attack: \(pokemon!.attack)"
        detailLabels[1].text = "Defense: \(pokemon!.defense)"
        detailLabels[2].text = "Health: \(pokemon!.health)"
        detailLabels[3].text = "Special Attack: \(pokemon!.specialAttack)"
        detailLabels[4].text = "Special Defense: \(pokemon!.specialDefense)"
        detailLabels[5].text = "Speed: \(pokemon!.speed)"
        detailLabels[6].text = "Total: \(pokemon!.total)"
        for type in (pokemon!.types) {
            detailLabels[7].text = "Types: \(type)" 
        }
        
        view.addSubview(titleLabel)
        view.addSubview(pokemonImage)
        view.addSubview(mainViewStack)
        mainViewStack.addArrangedSubview(detailLabels[0])
        mainViewStack.addArrangedSubview(detailLabels[1])
        mainViewStack.addArrangedSubview(detailLabels[2])
        mainViewStack.addArrangedSubview(detailLabels[3])
        mainViewStack.addArrangedSubview(detailLabels[4])
        mainViewStack.addArrangedSubview(detailLabels[5])
        mainViewStack.addArrangedSubview(detailLabels[6])
        mainViewStack.addArrangedSubview(detailLabels[7])
        view.addSubview(returnButton)

        
        NSLayoutConstraint.activate([
            returnButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 700),
            returnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 75),
            returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -75),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            pokemonImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            pokemonImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            pokemonImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            mainViewStack.topAnchor.constraint(equalTo: pokemonImage.bottomAnchor, constant: 10),
            mainViewStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainViewStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        }
    
    
    @objc func didTapReturn(_ sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

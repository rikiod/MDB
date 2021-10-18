//
//  PokedexVC.swift
//  Pokedex
//
//  Created by Michael Lin on 2/18/21.
//

import UIKit

class PokedexVC: UIViewController {
        
    var pokemons = PokemonGenerator.shared.getPokemonArray()
    var gridDisplay: Bool = false
    var selPokemons: [Pokemon]?
            
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.reuseIdentifier)
        return collectionView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Pokédex"
        label.textAlignment = .center
        label.textColor = .systemGreen
        label.font = .boldSystemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let layoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        button.tintColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar.init(frame: .zero)
        
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(layoutButton)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 225, left: 35, bottom: 0, right: 35))
        
        searchBar.setShowsCancelButton(true, animated: false)
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.showsScopeBar = true
        searchBar.isTranslucent = false
        searchBar.placeholder = "Find a Pokemon..."
        searchBar.tintColor = .systemGreen
        searchBar.barTintColor = .white
        let safeArea = view.safeAreaInsets
        searchBar.frame = CGRect.init(x: view.bounds.width / 10, y: safeArea.top + 140, width: view.bounds.width, height: 40)
        
        selPokemons = pokemons
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            layoutButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            layoutButton.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 50),
        ])
        
        layoutButton.addTarget(self, action: #selector(didTapLayout(_:)), for: .touchUpInside)

    }
    
    @objc func didTapLayout(_ sender:UIButton) {
        if gridDisplay {
                gridDisplay = false
        }
        else {
                gridDisplay = true
        }
                collectionView.performBatchUpdates(nil, completion: nil)
    }
}


extension PokedexVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selPokemons!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pokemon = selPokemons?[indexPath.item]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.reuseIdentifier, for: indexPath) as! PokemonCell
        cell.pokemon = pokemon
        return cell
    }
}


extension PokedexVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if gridDisplay {
            layoutButton.setImage(UIImage(systemName: "square.grid.2x2.fill"), for: .normal)
            return CGSize(width: view.frame.width / 3, height: view.frame.width / 3)
        }
        else {
            layoutButton.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
            return CGSize(width: 100, height: 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at: indexPath) as! PokemonCell
        let vc = DetailsVC(data: tappedCell.pokemon!)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}


extension PokedexVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        selPokemons = pokemons.filter({ r in
            r.name.contains(searchText)
        })
        if selPokemons?.count == 0 {
            selPokemons = PokemonGenerator.shared.getPokemonArray()
        }

        collectionView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        selPokemons = pokemons
        collectionView.reloadData()
    }
}


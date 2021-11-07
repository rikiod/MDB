//
//  CollectionVC.swift
//  SFSymbolCollection
//
//  Created by Michael Lin on 2/22/21.
//

import UIKit

class SymbolCollectionVC: UIViewController {
    
    typealias Section = SymbolCategories
    
    static let headerElementKind = "symbol-header-kind"
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, SFSymbol>!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureViews()
        configureDataSource()
    }
}

extension SymbolCollectionVC {
    func createLayout() -> UICollectionViewLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 40
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let category = Section(index: sectionIndex) else { fatalError("Unknown section kind") }
            
            let itemsPerRow = 4
            let rowHeight: CGFloat = 70.0
            let rowSpacing: CGFloat = 35
            let headerEstimatedHeight: CGFloat = 44
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / CGFloat(itemsPerRow)),
                                                   heightDimension: .absolute(rowHeight)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3)
            
            let row = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(rowHeight)), subitems: [item])
            
            let rowGroupEstimatedHeight = rowHeight * CGFloat(category.numberOfRows()) +
                rowSpacing * CGFloat(category.numberOfRows() - 1)
            let rowGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(rowGroupEstimatedHeight)),
                subitem: row, count: category.numberOfRows())
            
            rowGroup.interItemSpacing = .fixed(rowSpacing)
            
            let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .estimated(headerEstimatedHeight + rowHeight * CGFloat(category.numberOfRows()))), subitems: [rowGroup])
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = category.getScrollingBehavior()
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalHeight(1.0), heightDimension: .estimated(headerEstimatedHeight)),
                elementKind: SymbolCollectionVC.headerElementKind, alignment: .topLeading)
            
            section.boundarySupplementaryItems = [sectionHeader]
            return section
                    
        }, configuration: config)
        
        return layout
    }
}

extension SymbolCollectionVC {
    func configureViews() {
        let layout = createLayout()
        collectionView = UICollectionView(
            frame: view.bounds.inset(by: UIEdgeInsets(top: 88, left: 0, bottom: 0, right: 0)),
            collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        view.addSubview(collectionView)
    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<SymbolCollectionCell, SFSymbol> {
            (cell, indexPath, identifier) in
            cell.symbol = identifier
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: SymbolCollectionVC.headerElementKind) { headerView, elementKind, indexPath in
            guard let section = Section(index: indexPath.section) else {
                fatalError("Unknown section")
            }
            headerView.label.text = section.rawValue
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, SFSymbol>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: SFSymbol) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        dataSource.supplementaryViewProvider = {
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        dataSource.apply(genereateSnapshot(), animatingDifferences: false)
    }
    
    func genereateSnapshot() -> NSDiffableDataSourceSnapshot<Section, SFSymbol> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SFSymbol>()
        SymbolCategories.allCases.forEach { category in
            guard let items = SymbolProvider.symbols?[category] else {
                fatalError("Unknown category")
            }
            snapshot.appendSections([category])
            snapshot.appendItems(items)
        }
        
        return snapshot
    }
}

//
//  ViewController.swift
//  HelloWorldListView
//
//  Created by Tim Duckett on 27.06.20.
//

import UIKit

struct Item: Hashable {
    var title: String
    var subtitle: String
    var image: UIImage
}

enum Section: CaseIterable {
    case main
    case second
}

class ViewController: UIViewController {
    
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    
    var collectionView: UICollectionView!
    
    let mainSectionItems = (1...10).map { index -> Item in
        return Item(title: "Item \(index)", subtitle: "First section", image: UIImage(named: "unicorn")!)
    }
    
    let secondSectionItems = (1...10).map { index -> Item in
        return Item(title: "Element \(index)", subtitle: "Second section", image: UIImage(named: "panda")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureDataSource()
        applyInitialData()
    }

}

extension ViewController {
    
    private func configureLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: self.configureLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            content.textProperties.color = UIColor.blue
            content.secondaryText = item.subtitle
            content.image = item.image
            cell.contentConfiguration = content
        }
        
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        })
            
    }
    
    private func applyInitialData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main, .second])
        snapshot.appendItems(mainSectionItems, toSection: .main)
        snapshot.appendItems(secondSectionItems, toSection: .second)
        datasource.apply(snapshot, animatingDifferences: false)
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item at indexPath \(indexPath) selected!")
    }
    
}


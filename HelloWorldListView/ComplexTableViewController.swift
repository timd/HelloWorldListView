//
//  ComplexTableViewController.swift
//  HelloWorldListView
//
//  Created by Tim Duckett on 28.06.20.
//

import UIKit

class ComplexTableViewController: UIViewController {

    var collectionView: UICollectionView!
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private let refreshControl = UIRefreshControl()
    var navigationBar: UINavigationBar!
    
    lazy var mainSectionItems = (1...30).map { index -> Item in
        return Item(title: "Item \(index)", subtitle: "First section", image: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        configureCollectionView()
        configureDataSource()
        refreshList()
    }

}

extension ComplexTableViewController {
    
    private func setupNavigationBar() {
        navigationBar = UINavigationBar()
        view.addSubview(navigationBar)
        
        let navItem = UINavigationItem(title: "Swipe table")
        let doneItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                       target: nil,
                                       action: #selector(resetData))
        navItem.rightBarButtonItem = doneItem
        
        navigationBar.setItems([navItem], animated: false)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: self.configureLayout())
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        refreshControl.addTarget(self, action: #selector(resetData), for: .valueChanged)
        collectionView.refreshControl = refreshControl

    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var config = cell.defaultContentConfiguration()
            config.text = item.title
            config.textProperties.color = UIColor.blue
            config.secondaryText = "\(item.uuid)"
            config.image = item.image
            cell.contentConfiguration = config
            
            let deleteAction = UIContextualAction(style: .destructive,
                                            title: "Delete") { (action, view, completion) in
                self.deleteItem(withItem: item)
                self.refreshList()
                completion(true)
            }
            
            cell.trailingSwipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
            
            let infoAction = UIContextualAction(style: .normal, title: "Info") { (action, view, completion) in
                self.displayInfoFor(item: item)
                completion(true)
            }
            
            cell.leadingSwipeActionsConfiguration = UISwipeActionsConfiguration(actions: [infoAction])
            
        }
        
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        })
            
    }
    
    private func deleteItem(withItem item: Item) {
        if let index = mainSectionItems.firstIndex(of: item) {
            mainSectionItems.remove(at: index)
        }
    }
    
    private func displayInfoFor(item: Item) {
        let alert = UIAlertController(title: "Info about item",
                                      message: "The item's UUID is \(item.uuid)",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func refreshList() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(mainSectionItems, toSection: .main)
        datasource.apply(snapshot, animatingDifferences: false)
    }
    
    @objc
    private func resetData() {
        mainSectionItems = (1...30).map { index -> Item in
            return Item(title: "Item \(index)", subtitle: "First section", image: nil)
        }
        refreshControl.endRefreshing()
        refreshList()
    }
    
}

extension ComplexTableViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item at indexPath \(indexPath) selected!")
    }
    
}


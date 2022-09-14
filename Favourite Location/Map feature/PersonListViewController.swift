//
//  PersonListViewController.swift
//  Favourite Location
//
//  Created by Mohammad Javad Bashtani on 6/20/1401 AP.
//

import UIKit


class PersonListViewController: UICollectionViewController {
    var loadData: (() -> Void)?
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, CellController> = {
        .init(collectionView: collectionView) { (collectionView, index, controller) in
            controller.dataSource.collectionView(collectionView, cellForItemAt: index)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = dataSource
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PersonCollectionViewCell.self))
        
        
        // Do any additional setup after loading the view.
    }
    
    func display(_ sections: [CellController]...) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
        sections.enumerated().forEach { section, cellControllers in
            snapshot.appendSections([section])
            snapshot.appendItems(cellControllers, toSection: section)
        }
        dataSource.apply(snapshot)
    }
    
    func display(isLoading: Bool) {
        isLoading ? (view.showIndicator()) : (view.hideIndicator())
    }
    
    init(collectionFlowViewLayout layout: UICollectionViewFlowLayout = .init()) {
        layout.estimatedItemSize =  UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.collectionView?(collectionView, didSelectItemAt: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.collectionView?(collectionView, didDeselectItemAt: indexPath)
    }
    
    private func cellController(at indexPath: IndexPath) -> CellController? {
        dataSource.itemIdentifier(for: indexPath)
    }
    
}









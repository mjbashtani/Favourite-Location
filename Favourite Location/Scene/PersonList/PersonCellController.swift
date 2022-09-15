//
//  PersonCellController.swift
//  Favourite Location
//
//  Created by Mohammad Javad Bashtani on 6/21/1401 AP.
//

import Foundation
import UIKit

class PersonCellController: NSObject {
    private let viewModel: PersonCellViewModel
    var selection: (() -> Void)?
    var deselection: (() -> Void)?
    
    
    init(viewModel: PersonCellViewModel) {
        self.viewModel = viewModel
    }
    
    
    private func binded(_ cell: PersonCollectionViewCell, defaultSelection: Bool) -> PersonCollectionViewCell {
        cell.textLabel.text = viewModel.name + "" + viewModel.lastName
        cell.textLabel.backgroundColor = defaultSelection ? .systemFill : .clear
        return cell
    }
    
    private func handleSelection(cell: PersonCollectionViewCell, isSelected: Bool) {
        cell.textLabel.backgroundColor = isSelected ? .systemFill : .clear
    }
    
}

extension PersonCellController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PersonCollectionViewCell  = collectionView.dequeueReusableCell(for: indexPath)
        let defaultSelection = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
        return binded(cell, defaultSelection: defaultSelection)
    }
    
    
}

extension PersonCellController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PersonCollectionViewCell
        handleSelection(cell: cell, isSelected: true)
        selection?()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        deselection?()
        let cell = collectionView.cellForItem(at: indexPath) as! PersonCollectionViewCell
        handleSelection(cell: cell, isSelected: false)
    }
    
}





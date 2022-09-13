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
        cell.mainButton.setTitle(viewModel.name + "" + viewModel.lastName, for: .normal)
        cell.mainButton.backgroundColor = defaultSelection ? .systemFill : .clear
        viewModel.onSelection = { [weak cell] isSelected in
            cell?.mainButton.backgroundColor = isSelected ? .systemFill : .clear
        }
        return cell
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
        viewModel.select()
        selection?()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        deselection?()
        viewModel.deselect()
    }
}





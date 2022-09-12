//
//  PersonCellController.swift
//  Favourite Location
//
//  Created by Mohammad Javad Bashtani on 6/21/1401 AP.
//

import Foundation
import UIKit

class PersonCellController {
    private let viewModel: PersonViewModel
    
    
    init(viewModel: PersonViewModel) {
        self.viewModel = viewModel
    }
    
    func view(in collectionView: UICollectionView, for indexPath: IndexPath) -> PersonCollectionViewCell {
        let cell: PersonCollectionViewCell  = collectionView.dequeueReusableCell(for: indexPath)
        return binded(cell)
    }
    
    private func binded(_ cell: PersonCollectionViewCell) -> PersonCollectionViewCell {
        cell.mainButton.setTitle(viewModel.name + "" + viewModel.lastName, for: .normal)
        return cell
    }
}





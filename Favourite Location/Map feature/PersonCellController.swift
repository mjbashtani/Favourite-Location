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
    private var cell: PersonCollectionViewCell?
    
     init(viewModel: PersonViewModel) {
        self.viewModel = viewModel
    }
        
    func cancelLoad() {
        releaseCellForReuse()
    }
    
    func view(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(for: indexPath)
        cell?.configure(with: viewModel)
        return cell!
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}

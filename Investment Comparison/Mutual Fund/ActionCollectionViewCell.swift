//
//  ActionCollectionViewCell.swift
//  Investment Comparison
//
//  Created by Iskandar Herputra Wahidiyat on 24/06/22.
//

import UIKit

protocol ActionCollectionViewCellDelegate: AnyObject {
    func detailButtonDidTapped(cell: ActionCollectionViewCell, didTappedThe button: UIButton?)
    func buyButtonDidTapped(cell: ActionCollectionViewCell, didTappedThe button: UIButton?)
}

class ActionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    
    weak var cellDelegate: ActionCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func detailButtonDidTapped(_ sender: UIButton) {
        cellDelegate?.detailButtonDidTapped(cell: self, didTappedThe: sender)
    }
    
    @IBAction func buyButtonDidTapped(_ sender: UIButton) {
        cellDelegate?.buyButtonDidTapped(cell: self, didTappedThe: sender)
    }
}

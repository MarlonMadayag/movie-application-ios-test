//
//  MovieGroupListCollectionViewCell.swift
//  MovieApplicationIOS
//
//  Created by Marlon Madayag on 1/19/21.
//

import UIKit

class MovieGroupListCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieGroupListCollectionViewCell"
    
    @IBOutlet weak var movieImagePosterImageView: UIImageView!
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieGroupListCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

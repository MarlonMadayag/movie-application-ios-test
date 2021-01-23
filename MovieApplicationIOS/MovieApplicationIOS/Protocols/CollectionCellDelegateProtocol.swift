//
//  CollectionCellDelegateProtocol.swift
//  MovieApplicationIOS
//
//  Created by Marlon Madayag on 1/21/21.
//

import Foundation
import UIKit

protocol CollectionCellDelegateProtocol {
    func didClickACell(movieData: MovieInformation, moviePosterImage: UIImage)
    func didReachEndOfCollection(movieGroup: String)
}

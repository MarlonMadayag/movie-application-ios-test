//
//  NowPlayingMoviesTableViewCell.swift
//  MovieApplicationIOS
//
//  Created by Marlon Madayag on 1/20/21.
//

import UIKit

class NowPlayingMoviesTableViewCell: UITableViewCell {

    static let identifier = "NowPlayingMoviesTableViewCell"
    
    var delegate: CollectionCellDelegateProtocol?
    
    @IBOutlet weak var lblMovieGroup: UILabel!
    @IBOutlet weak var cvNowPlayingMoviesCollectionView: UICollectionView!
    
    var movieGroup: String?
    
    var movieList: [MovieInformation]? {
        didSet {
            DispatchQueue.main.async { self.cvNowPlayingMoviesCollectionView.reloadData() }
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "NowPlayingMoviesTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cvNowPlayingMoviesCollectionView.register(MovieGroupListCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieGroupListCollectionViewCell.identifier)
        cvNowPlayingMoviesCollectionView.delegate = self
        cvNowPlayingMoviesCollectionView.dataSource = self
        setNowPlayingMovieCollectionView(cellScale: 0.6)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setNowPlayingMovieCollectionView(cellScale: CGFloat) {
//        let screenSize = UIScreen.main.bounds.size
//        let cellWidth = floor(screenSize.width * cellScale)
//        let cellHeight = floor(screenSize.height * cellScale)
//        let insetX = (view.bounds.width - cellWidth) / 2.0
//        let insetY = (view.bounds.height - cellHeight) / 2.0
        let tableCell = NowPlayingMoviesTableViewCell()
        
        let screenSize = UIScreen.main.bounds.size
        
        print("Table cell width : \(tableCell.frame.width)")
        print("Collection view width : \(cvNowPlayingMoviesCollectionView.bounds.width)")
        print("Parent view width : \(screenSize.width)")
        print("Content view width : \(contentView.bounds.width)")
        
        let cellWidth = 200
        let cellHeight = 300
        let insetX = ((screenSize.width - CGFloat(cellWidth)) / 2.0)
        let insetY = (cvNowPlayingMoviesCollectionView.bounds.height - CGFloat(cellHeight)) / 2.0
    
        let layout = cvNowPlayingMoviesCollectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        cvNowPlayingMoviesCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
    }
    
}

extension NowPlayingMoviesTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! MovieGroupListCollectionViewCell
        let movieData = (movieList?[indexPath[1]])!

        print("Cell clicked!")
        self.delegate?.didClickACell(movieData: movieData, moviePosterImage: cell.movieImagePosterImageView.image!)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if movieList != nil && indexPath.row == (movieList?.count)! - 1 {

            print("End of collection view")
            self.delegate?.didReachEndOfCollection(movieGroup: "")
        }
    }
}

extension NowPlayingMoviesTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if movieList != nil {
            return (movieList?.count)!
        }
        else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movieGroupListCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieGroupListCollectionViewCell.identifier, for: indexPath) as! MovieGroupListCollectionViewCell

        if movieList != nil {
            let result = movieList![indexPath.row]
            let url = URL(string: "\(Constants.imageURL)w92/\(result.poster_path!)")
            
            movieGroupListCell.movieImagePosterImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "image"))
        }
        
        return movieGroupListCell
    }
}

extension NowPlayingMoviesTableViewCell: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.cvNowPlayingMoviesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        targetContentOffset.pointee = offset
    }
}

extension NowPlayingMoviesTableViewCell: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 200, height: 300)
//    }
}

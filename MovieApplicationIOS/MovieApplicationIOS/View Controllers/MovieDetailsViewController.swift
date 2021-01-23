//
//  MovieDetailsViewController.swift
//  MovieApplicationIOS
//
//  Created by Marlon Madayag on 1/19/21.
//

import UIKit
import PromiseKit

class MovieDetailsViewController: UIViewController {
    
    let moviesAPICalls = MoviesApiCalls()
    
    @IBOutlet weak var imgViewMoviePoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblAdultRating: UILabel!
    @IBOutlet weak var lblRuntime: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblCastMembers: UILabel!
    @IBOutlet weak var cvRecommendedSimilarMovie: UICollectionView!
    
    var movieCompleteDetail: MovieDetail?
    var movieDetail: MovieInformation?
    var moviePosterImage: UIImage?
    
    public func configure(with url: URL?) {
       
        DispatchQueue.main.async {
//            print(url)
//            self.imgViewMoviePoster.sd_setImage(with: url, placeholderImage: self.moviePosterImage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let viewWidth = view.frame.size.width
        let spacing = (viewWidth - (100 * 3)) / 4
        layout.sectionInset = UIEdgeInsets(top: 5, left: spacing, bottom: 5, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.cvRecommendedSimilarMovie.collectionViewLayout = layout

        // Do any additional setup after loading the view.
        lblTitle.text = movieDetail?.title
        let frame = CGRect(x: 0, y: 0, width: 300, height: 600)
        imgViewMoviePoster.frame = frame
        imgViewMoviePoster.image = moviePosterImage
        
        cvRecommendedSimilarMovie.register(MovieGroupListCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieGroupListCollectionViewCell.identifier)
        cvRecommendedSimilarMovie.delegate = self
        cvRecommendedSimilarMovie.dataSource = self
        
        getMovieDetail(movieId: movieDetail!.id)
        getMovieCredits(movieId: movieDetail!.id)
        getRecommendationMovies(movieId: movieDetail!.id)
    }
    
    func getMovieCredits(movieId: Int) {
        firstly {
            moviesAPICalls.getMovieCredits(movieId: movieId)
        }
        .ensure {
            
        }
        .done { movieCredits in
            let castCount = movieCredits.cast.count
            
            if castCount > 3 {
                self.lblCastMembers.text = "\(movieCredits.cast[0].name), \(movieCredits.cast[1].name), \(movieCredits.cast[2].name)"
            }
            else {
                for cast in movieCredits.cast {
                    self.lblCastMembers.text = self.lblCastMembers.text ?? "" + cast.name
                }
            }
        }
        .catch { error in
            print("Catch: \(error)")
        }
    }
    
    func getMovieDetail(movieId: Int) {
        firstly {
            moviesAPICalls.getMovieDetailsPromise(movieId: movieId)
        }
        .ensure {
            
        }
        .done { movieCompleteDetail in
            self.movieCompleteDetail = movieCompleteDetail
            self.lblYear.text = movieCompleteDetail.release_date
            let runtime = movieCompleteDetail.runtime
            self.lblRuntime.text = "\(Int(runtime/60))h\(runtime%60)m"
            self.lblOverview.text = movieCompleteDetail.overview
        }
        .catch { error in
            print("Catch: \(error)")
        }
    }
    
    func getRecommendationMovies(movieId: Int) {
        firstly {
            moviesAPICalls.getRecommendationBaseOnMovie(movieId: movieId)
        }
        .ensure {
            
        }
        .done { recommendedMovies in
            print(recommendedMovies)
        }
        .catch { error in
            print("Catch: \(error)")
        }
    }
    
}

extension MovieDetailsViewController: UICollectionViewDelegate {
    
}

extension MovieDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieGroupListCollectionViewCell.identifier, for: indexPath) as! MovieGroupListCollectionViewCell
        
        cell.movieImagePosterImageView.image = UIImage(named: "image")
        
        return cell
    }
}

extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 150)
    }
}

//
//  MoviesHomeViewController.swift
//  MovieApplicationIOS
//
//  Created by Marlon Madayag on 1/19/21.
//

import UIKit
import PromiseKit
import SDWebImage

class MoviesHomeViewController: UIViewController {
    
    let moviesAPICalls = MoviesApiCalls()
    
    var latestMovieDetail: MovieDetail?
    var movieData: MovieInformation?
    var moviePosterImage: UIImage?
    
    var upcomingMovies: MovieList?
    var upcomingMoviesList = [MovieInformation]()
    var upComingMoviesPage: Int = 1
    
    var nowPlayingMovies: MovieList?
    var nowPlayingMoviesList = [MovieInformation]()
    var nowPlayingMoviesPage: Int = 1
    
    var popularMovies: MovieList?
    var popularMoviesList = [MovieInformation]()
    var popularMoviesPage: Int = 1
    
    var topRatedMovies: MovieList?
    var topRatedMoviesList = [MovieInformation]()
    var topRatedMoviesPage: Int = 1
    
    @IBOutlet weak var moviesHomeTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        moviesHomeTableView.register(LatestMovieTableViewCell.nib(), forCellReuseIdentifier: LatestMovieTableViewCell.identifier)
        moviesHomeTableView.register(MoviesListTableViewCell.nib(), forCellReuseIdentifier: MoviesListTableViewCell.identifier)
        moviesHomeTableView.register(NowPlayingMoviesTableViewCell.nib(), forCellReuseIdentifier: NowPlayingMoviesTableViewCell.identifier)
        moviesHomeTableView.delegate = self
        moviesHomeTableView.dataSource = self
        

        getLatestMovie()
        getUpcomingMovies(page: upComingMoviesPage)
        getNowPlayingMovies(page: nowPlayingMoviesPage)
        getPopularMovies(page: popularMoviesPage)
        getTopRatedMovies(page: topRatedMoviesPage)
        
    }
    
    func getLatestMovie() {
        firstly {
            moviesAPICalls.getLatestMoviePromise()
        }
        .ensure {
            
        }
        .done { latestMovieDetail in
            self.latestMovieDetail = latestMovieDetail
            DispatchQueue.main.async { self.moviesHomeTableView.reloadData() }
        }
        .catch { error in
            print("Catch: \(error)")
        }
    }
    
    func getNowPlayingMovies(page: Int) {
        firstly {
            moviesAPICalls.getNowPlayingMoviesPromise(page: page)
        }
        .ensure {
            
        }
        .done { nowPlayingMovies in
            self.nowPlayingMovies = nowPlayingMovies
            self.nowPlayingMoviesPage = nowPlayingMovies.page
            self.nowPlayingMoviesList = self.nowPlayingMoviesList + nowPlayingMovies.results
            DispatchQueue.main.async { self.moviesHomeTableView.reloadData() }
        }
        .catch { error in
            print("Catch: \(error)")
        }
    }
    
    func getPopularMovies(page: Int) {
        firstly {
            moviesAPICalls.getPopularMoviesPromise(page: page)
        }
        .ensure {
            
        }
        .done { popularMovies in
            self.popularMovies = popularMovies
            self.popularMoviesPage = popularMovies.page
            self.popularMoviesList = self.popularMoviesList + popularMovies.results
            DispatchQueue.main.async { self.moviesHomeTableView.reloadData() }
        }
        .catch { error in
            print("Catch: \(error)")
        }
    }
    
    func getTopRatedMovies(page: Int) {
        firstly {
            moviesAPICalls.getTopRatedMoviesPromise(page: page)
        }
        .ensure {
            
        }
        .done { topRatedMovies in
            self.topRatedMovies = topRatedMovies
            self.topRatedMoviesPage = topRatedMovies.page
            self.topRatedMoviesList = self.topRatedMoviesList + topRatedMovies.results
            DispatchQueue.main.async { self.moviesHomeTableView.reloadData() }
        }
        .catch { error in
            print("Catch: \(error)")
        }
    }
    
    func getUpcomingMovies(page: Int) {
        firstly {
            moviesAPICalls.getUpcomingMoviesPromise(page: page)
        }
        .ensure {
            
        }
        .done { upcomingMovies in
            self.upcomingMovies = upcomingMovies
            self.upComingMoviesPage = upcomingMovies.page
            self.upcomingMoviesList = self.upcomingMoviesList + upcomingMovies.results
            DispatchQueue.main.async { self.moviesHomeTableView.reloadData() }
        }
        .catch { error in
            print("Catch: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is MovieDetailsViewController
        {
            let movieDetailsVC = segue.destination as? MovieDetailsViewController
            let posterPath = movieData?.poster_path
            
            if posterPath != nil {
                let url = URL(string: "\(Constants.imageURL)w342/\((posterPath!))")
                movieDetailsVC?.configure(with: url)
            }
            
            movieDetailsVC?.movieDetail = self.movieData
            movieDetailsVC?.moviePosterImage = self.moviePosterImage
            
        }
    }

}

extension MoviesHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 810
        }
        else if indexPath.row == 1 {
            return 330
        }
        else if indexPath.row <= 3 {
            return 180
        }
        
        return 0
    }
}

extension MoviesHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let latestMovieCell = tableView.dequeueReusableCell(withIdentifier: LatestMovieTableViewCell.identifier, for: indexPath) as! LatestMovieTableViewCell
            
            latestMovieCell.movieList = self.upcomingMoviesList
            
            if latestMovieDetail?.poster_path != nil {
                let url = URL(string: "\(Constants.imageURL)original/\((latestMovieDetail?.poster_path)!)")
                
                latestMovieCell.latestMoviePosterImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "image"))
            }
            
            latestMovieCell.delegate = self
            return latestMovieCell
        }
        else if indexPath.row == 1 {
            let nowPlayingMovieListCell = tableView.dequeueReusableCell(withIdentifier: NowPlayingMoviesTableViewCell.identifier, for: indexPath) as! NowPlayingMoviesTableViewCell
            
            nowPlayingMovieListCell.movieList = self.nowPlayingMoviesList
            nowPlayingMovieListCell.lblMovieGroup.text = Constants.MovieGroup.nowPlaying
            nowPlayingMovieListCell.movieGroup = Constants.MovieGroup.nowPlaying
            
            return nowPlayingMovieListCell
            
        }
        else if indexPath.row == 2 {
            let popularMovieListCell = tableView.dequeueReusableCell(withIdentifier: MoviesListTableViewCell.identifier, for: indexPath) as! MoviesListTableViewCell

            popularMovieListCell.movieList = self.popularMoviesList
            popularMovieListCell.lblMovieGroup.text = Constants.MovieGroup.popular
            popularMovieListCell.movieGroup = Constants.MovieGroup.popular
            popularMovieListCell.delegate = self
            return popularMovieListCell
        }
        else if indexPath.row == 3 {
            let topRatedMovieListCell = tableView.dequeueReusableCell(withIdentifier: MoviesListTableViewCell.identifier, for: indexPath) as! MoviesListTableViewCell
            
            topRatedMovieListCell.movieList = self.topRatedMoviesList
            topRatedMovieListCell.lblMovieGroup.text = Constants.MovieGroup.topRated
            topRatedMovieListCell.movieGroup = Constants.MovieGroup.topRated
            topRatedMovieListCell.delegate = self
            
            return topRatedMovieListCell
        }
        
        return UITableViewCell()
    }
}

extension MoviesHomeViewController: CollectionCellDelegateProtocol {
    func didClickACell(movieData: MovieInformation, moviePosterImage: UIImage) {
        
        self.movieData = movieData
        self.moviePosterImage = moviePosterImage
        
        performSegue(withIdentifier: "MovieDetailsViewController", sender: self)
    }
    
    func didReachEndOfCollection(movieGroup: String) {
        if movieGroup == "" {
            if upComingMoviesPage < upcomingMovies!.total_pages {
                getUpcomingMovies(page: upComingMoviesPage + 1)
            }
            print("End of collection called in movie home controller : Table cell 1")
        }
    }
}

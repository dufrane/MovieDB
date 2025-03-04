//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 25.02.2025.
//

import UIKit
import SDWebImage

final class MovieDetailViewController: UIViewController {
    private let viewModel: MovieDetailViewModel
    private let movie: Movie
    
    private let backdropImageView = UIImageView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let castCollectionView: UICollectionView
    
    init(viewModel: MovieDetailViewModel, movie: Movie) {
        self.viewModel = viewModel
        self.movie = movie
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 150)
        self.castCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMovieData()
    }
    
// MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .black
        
        backdropImageView.contentMode = .scaleAspectFill
        posterImageView.contentMode = .scaleAspectFit
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white
        overviewLabel.font = .systemFont(ofSize: 16)
        overviewLabel.textColor = .lightGray
        overviewLabel.numberOfLines = 0
        
        castCollectionView.register(ActorCell.self, forCellWithReuseIdentifier: "ActorCell")
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, overviewLabel, castCollectionView])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        view.addSubview(backdropImageView)
        view.addSubview(posterImageView)
        view.addSubview(stackView)
        
        backdropImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backdropImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalToConstant: 200),
            
            posterImageView.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -40),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),
            
            stackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
// MARK: - Fetch Movie Data
    private func fetchMovieData() {
        viewModel.fetchMovieDetail(movieID: movie.id) { [weak self] in
            self?.updateUI()
        }
        viewModel.fetchMovieCast(movieID: movie.id) { [weak self] in
            self?.castCollectionView.reloadData()
        }
    }
    
// MARK: - Update UI
    private func updateUI() {
        guard let detail = viewModel.movieDetail else { return }
        titleLabel.text = detail.title
        overviewLabel.text = detail.overview
        posterImageView.sd_setImage(with: detail.posterURL, placeholderImage: UIImage(systemName: "photo"))
        backdropImageView.sd_setImage(with: detail.backdropURL, placeholderImage: UIImage(systemName: "photo"))
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActorCell", for: indexPath) as? ActorCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.cast[indexPath.row])
        return cell
    }
}

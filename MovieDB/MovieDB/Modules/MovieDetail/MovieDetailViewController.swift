//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 25.02.2025.
//

import UIKit

protocol MovieDetailViewProtocol: AnyObject {
    func showMovieDetail(_ detail: MovieDetail)
    func showCast(_ cast: [Actor])
}

import UIKit

final class MovieDetailViewController: UIViewController, MovieDetailViewProtocol {
    
    private var presenter: MovieDetailPresenterProtocol?
    private let movie: Movie
    private var actors: [Actor] = []
    
    private let backdropImageView = UIImageView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    
    private let castCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 150)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ActorCell.self, forCellWithReuseIdentifier: ActorCell.reuseIdentifier)
        return collectionView
    }()
    
    init(presenter: MovieDetailPresenterProtocol, movie: Movie) {
        self.presenter = presenter
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        backdropImageView.contentMode = .scaleAspectFill
        posterImageView.contentMode = .scaleAspectFit
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white
        overviewLabel.font = .systemFont(ofSize: 16)
        overviewLabel.textColor = .lightGray
        overviewLabel.numberOfLines = 0
        
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
            backdropImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backdropImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalToConstant: 200),
            
            posterImageView.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -40),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),
            
            stackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 26),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func showMovieDetail(_ detail: MovieDetail) {
        print("showMovieDetail called on Main Thread:", Thread.isMainThread)
        titleLabel.text = detail.title
        overviewLabel.text = detail.overview
        posterImageView.sd_setImage(with: detail.posterURL, placeholderImage: UIImage(systemName: "photo"))
        backdropImageView.sd_setImage(with: detail.backdropURL, placeholderImage: UIImage(systemName: "photo"))
    }
    
    func showCast(_ cast: [Actor]) {
        print("🎬 Loaded cast: \(cast.count) actors") // ✅ Лог для перевірки
        self.actors = cast
        DispatchQueue.main.async {
            self.castCollectionView.reloadData()
        }
    }
    
}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorCell.reuseIdentifier, for: indexPath) as? ActorCell else {
                return UICollectionViewCell()
            }
            let actor = actors[indexPath.row]
            cell.configure(with: actor)
            return cell
        }
}

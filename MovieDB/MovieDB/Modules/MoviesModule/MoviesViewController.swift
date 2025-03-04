//
//  ViewController.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import UIKit

protocol MoviesViewProtocol: AnyObject {
    func showMovies(_ movies: [Movie])
    func showError(_ message: String)
}

final class MoviesViewController: UIViewController, MoviesViewProtocol {

    private var presenter: MoviesPresenterProtocol?
    
    private var movies: [Movie] = []

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 32, height: 300)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        return collectionView
    }()

    init(presenter: MoviesPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoaded()
    }

    // ✅ Реалізуємо функцію, щоб відобразити фільми
    func showMovies(_ movies: [Movie]) {
        self.movies = movies
        print("✅ showMovies called, movies count: \(movies.count)")
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func showError(_ message: String) {
        print("Error: \(message)")
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("✅ numberOfItemsInSection called: \(movies.count)")
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("✅ cellForItemAt called for indexPath: \(indexPath.row)")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        let movie = movies[indexPath.row]
        cell.configure(with: movie, isFavorite: false) // 👈 Якщо потрібно — сюди можна додати логику для обраного статусу
        
        print(movies)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        presenter?.didSelectMovie(movie)
    }
}

extension MoviesViewController: MovieCellDelegate {
    func didTapFavoriteButton(for movie: Movie) {
        // 👇 Якщо потрібно оновити статус обраного
        print("Favorite tapped for movie: \(movie.title)")
    }
}

//
//  ViewController.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import UIKit
import Combine

final class MoviesViewController: UIViewController {
    
    private let viewModel: MoviesViewModel
    private var cancellables = Set<AnyCancellable>()
    
// MARK: - UI Elements
    private let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search movies..."
        search.searchBar.searchBarStyle = .minimal
        return search
    }()
    
    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let popularButton: UIButton = {
        let button = UIButton()
        button.setTitle("Popular", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let topRatedButton: UIButton = {
        let button = UIButton()
        button.setTitle("Top Rated", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let upcomingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Upcoming", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 8
        return button
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 32, height: 300)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        return collectionView
    }()

// MARK: - Init
    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupActions()
        
        fetchMovies(from: .popular)
    }

// MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        view.addSubview(categoryStackView)
        view.addSubview(collectionView)

        categoryStackView.addArrangedSubview(popularButton)
        categoryStackView.addArrangedSubview(topRatedButton)
        categoryStackView.addArrangedSubview(upcomingButton)

        collectionView.dataSource = self
        collectionView.delegate = self

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0 ),
            categoryStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryStackView.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: categoryStackView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

// MARK: - Bindings
    private func setupBindings() {
        viewModel.$movies
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in self?.collectionView.reloadData() }
                .store(in: &viewModel.cancellables)

            viewModel.$favoriteMovies
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in self?.collectionView.reloadData() }
                .store(in: &viewModel.cancellables)
        }

// MARK: - Actions
    private func setupActions() {
        popularButton.addTarget(self, action: #selector(didTapCategory(_:)), for: .touchUpInside)
        topRatedButton.addTarget(self, action: #selector(didTapCategory(_:)), for: .touchUpInside)
        upcomingButton.addTarget(self, action: #selector(didTapCategory(_:)), for: .touchUpInside)
    }

    @objc private func didTapCategory(_ sender: UIButton) {

        resetCategoryButtonStyles()
        sender.backgroundColor = .systemBlue
        if sender == popularButton {
            fetchMovies(from: .popular)
        } else if sender == topRatedButton {
            fetchMovies(from: .topRated)
        } else if sender == upcomingButton {
            fetchMovies(from: .upcoming)
        }
    }

    private func resetCategoryButtonStyles() {
        popularButton.backgroundColor = .systemGray
        topRatedButton.backgroundColor = .systemGray
        upcomingButton.backgroundColor = .systemGray
    }

    private func fetchMovies(from category: APIService.MovieEndpoint) {
        viewModel.fetchMovies(from: category)
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        let movie = viewModel.movies[indexPath.row]
        cell.configure(with: movie, isFavorite: viewModel.isFavorite(movie: movie))
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movies[indexPath.row]
        viewModel.didSelectMovie(movie: movie)
    }
}

// MARK: - UISearchResultsUpdating
extension MoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            viewModel.fetchMovies(from: .popular)
            return
        }
        viewModel.searchMovies(query: query)
    }
}

// MARK: - UISearchBarDelegate
extension MoviesViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.fetchMovies(from: .popular)
    }
}

// MARK: - MovieCellDelegate
extension MoviesViewController: MovieCellDelegate {
    func didTapFavoriteButton(for movie: Movie) {
        viewModel.toggleFavorite(movie: movie)
    }
}

//
//  ViewController.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import UIKit

final class MoviesViewController: UIViewController {
    
    private let viewModel: MoviesViewModel
    private let detailViewModel: MovieDetailViewModel
    
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
    
    private let popularButton: UIButton = createCategoryButton(title: "Popular")
    private let topRatedButton: UIButton = createCategoryButton(title: "Top Rated")
    private let upcomingButton: UIButton = createCategoryButton(title: "Upcoming")
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 32, height: 300)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        return collectionView
    }()
    
// MARK: - Init
    init(viewModel: MoviesViewModel, detailViewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        self.detailViewModel = detailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        fetchMovies(from: .popular)
        popularButton.backgroundColor = .systemBlue
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
    
// MARK: - Actions
    private func setupActions() {
        popularButton.addTarget(self, action: #selector(didTapCategory(_:)), for: .touchUpInside)
        topRatedButton.addTarget(self, action: #selector(didTapCategory(_:)), for: .touchUpInside)
        upcomingButton.addTarget(self, action: #selector(didTapCategory(_:)), for: .touchUpInside)
    }
    
    @objc private func didTapCategory(_ sender: UIButton) {
        resetCategoryButtonStyles()
        sender.backgroundColor = .systemBlue
        let category: APIService.MovieEndpoint
        
        if sender == popularButton {
            category = .popular
        } else if sender == topRatedButton {
            category = .topRated
        } else {
            category = .upcoming
        }
        
        fetchMovies(from: category)
    }
    
    private func resetCategoryButtonStyles() {
        popularButton.backgroundColor = .systemGray
        topRatedButton.backgroundColor = .systemGray
        upcomingButton.backgroundColor = .systemGray
    }
    
    private func fetchMovies(from category: APIService.MovieEndpoint) {
        viewModel.fetchMovies(from: category) { [weak self] in
            self?.moviesFetched()
        }
    }
    
    private func moviesFetched() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
        detailViewModel.didSelectMovie(movie: movie)
    }
}

// MARK: - UISearchResultsUpdating
extension MoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            fetchMovies(from: .popular)
            return
        }
        
        viewModel.searchMovies(query: query) { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension MoviesViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchMovies(from: .popular)
    }
}

// MARK: - MovieCellDelegate
extension MoviesViewController: MovieCellDelegate {
    func didTapFavoriteButton(for movie: Movie) {
        viewModel.toggleFavorite(movie: movie)
        collectionView.reloadData()
    }
}

// MARK: - UI Helper
private extension MoviesViewController {
    static func createCategoryButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.addShaddowOnView()
        return button
    }
}

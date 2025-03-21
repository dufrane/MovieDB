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
    
    var presenter: MoviesPresenterProtocol?
    private var movies: [Movie] = []
    
    // MARK: - UI Components
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
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        return searchController
    }()
    
    // MARK: - Init
    init(presenter: MoviesPresenterProtocol?) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        presenter?.fetchMovies(from: .popular)
    }
    
    // MARK: - Setup UI
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
        updateActiveCategory(selectedButton: popularButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            categoryStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryStackView.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: categoryStackView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupActions() {
        popularButton.addTarget(self, action: #selector(didTapCategoryButton(_:)), for: .touchUpInside)
        topRatedButton.addTarget(self, action: #selector(didTapCategoryButton(_:)), for: .touchUpInside)
        upcomingButton.addTarget(self, action: #selector(didTapCategoryButton(_:)), for: .touchUpInside)
    }
    
    // MARK: - Handle Category Button Tap
    @objc private func didTapCategoryButton(_ sender: UIButton) {
        switch sender {
        case popularButton:
            presenter?.resetPagination()
            presenter?.fetchMovies(from: .popular)
        case topRatedButton:
            presenter?.resetPagination()
            presenter?.fetchMovies(from: .topRated)
        case upcomingButton:
            presenter?.resetPagination()
            presenter?.fetchMovies(from: .upcoming)
        default:
            break
        }
        
        updateActiveCategory(selectedButton: sender)
    }
    
    // MARK: - Update Active Category
    private func updateActiveCategory(selectedButton: UIButton) {
        let buttons = [popularButton, topRatedButton, upcomingButton]
        
        buttons.forEach { button in
            button.backgroundColor = button == selectedButton ? .systemBlue : .clear
            button.setTitleColor(button == selectedButton ? .white : .systemBlue, for: .normal)
            button.layer.cornerRadius = 8
            button.layer.borderWidth = button == selectedButton ? 0 : 1
            button.layer.borderColor = UIColor.systemBlue.cgColor
        }
    }
    
    // MARK: - Show Movies
    func showMovies(_ movies: [Movie]) {
        self.movies = movies
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Show Error
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        let movie = movies[indexPath.row]
        cell.configure(with: movie, isFavorite: movie.isFavorite)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        presenter?.didSelectMovie(movie: movie)
    }
}

// MARK: - UISearchResultsUpdating & UISearchBarDelegate
extension MoviesViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else { return }
        presenter?.searchMovies(query: query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.fetchMovies(from: .popular)
    }
}

// MARK: - MovieCellDelegate
extension MoviesViewController: MovieCellDelegate {
    func didTapFavoriteButton(for movie: Movie) {
        presenter?.toggleFavorite(movie: movie)
        collectionView.reloadData()
    }
}

private extension MoviesViewController {
    static func createCategoryButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 8
        button.addShaddowOnView()
        return button
    }
}

extension MoviesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        
        if offsetY > contentHeight - scrollViewHeight * 2,
           presenter?.hasMorePages == true,
           presenter?.isLoading == false {
            presenter?.fetchMovies(from: .popular)
        }
    }
}

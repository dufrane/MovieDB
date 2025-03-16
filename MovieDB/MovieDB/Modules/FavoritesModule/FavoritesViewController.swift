//
//  FavoritesViewController.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 25.02.2025.
//

import UIKit

protocol FavoritesViewProtocol: AnyObject {
    func showFavorites(_ favorites: [Movie])
}

final class FavoritesViewController: UIViewController, FavoritesViewProtocol {
    private var presenter: FavoritesPresenterProtocol?
    private var favoriteMovies: [Movie] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableCell.self, forCellReuseIdentifier: MovieTableCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(presenter: FavoritesPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter?.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func showFavorites(_ favorites: [Movie]) {
        self.favoriteMovies = favorites
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableCell.identifier, for: indexPath) as? MovieTableCell else {
            return UITableViewCell()
        }
        let movie = favoriteMovies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = favoriteMovies[indexPath.row]
        presenter?.didSelectMovie(movie)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

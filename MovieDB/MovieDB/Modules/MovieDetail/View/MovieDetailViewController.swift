//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 25.02.2025.
//

import UIKit
import SDWebImage
import Combine

final class MovieDetailViewController: UIViewController {
    private let viewModel: MovieDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    private let coordinator: MovieDetailCoordinatorProtocol
    private let movie: Movie
    
    private let backdropImageView = UIImageView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let castCollectionView: UICollectionView

    init(viewModel: MovieDetailViewModel, movie: Movie) {
        self.viewModel = viewModel
        self.movie = movie
        self.coordinator = viewModel.coordinator

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
        bindViewModel()
        viewModel.fetchMovieDetail(movieID: movie.id)
        viewModel.fetchMovieCast(movieID: movie.id)
    }

    private func setupUI() {
        view.backgroundColor = .black

        backdropImageView.contentMode = .scaleAspectFill
        posterImageView.contentMode = .scaleAspectFit

        titleLabel.font = .boldSystemFont(ofSize: 24)
        overviewLabel.font = .systemFont(ofSize: 16)
        overviewLabel.numberOfLines = 0

        castCollectionView.register(ActorCell.self, forCellWithReuseIdentifier: "ActorCell")
        castCollectionView.dataSource = self

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

    private func bindViewModel() {
        viewModel.$movieDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detail in
                guard let detail = detail else { return }
                self?.updateUI(with: detail)
            }.store(in: &cancellables)

        viewModel.$cast
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.castCollectionView.reloadData()
            }.store(in: &cancellables)
    }

    private func updateUI(with detail: MovieDetail) {
        titleLabel.text = detail.title
        overviewLabel.text = detail.overview
        posterImageView.sd_setImage(with: detail.posterURL)
        backdropImageView.sd_setImage(with: detail.backdropURL)
    }
}

// MARK: - UICollectionViewDataSource
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

//
//  MovieCell.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import UIKit
import SDWebImage

protocol MovieCellDelegate: AnyObject {
    func didTapFavoriteButton(for movie: Movie)
}

final class MovieCell: UICollectionViewCell {
    static let identifier = "MovieCell"

    private let movieImageView = UIImageView()
    private let titleLabel = UILabel()
    private let favoriteButton = UIButton()

    private var movie: Movie?
    weak var delegate: MovieCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(movieImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favoriteButton)

        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.tintColor = .gray

        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 250),

            titleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -5),

            favoriteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func setupActions() {
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
    }

    func configure(with movie: Movie, isFavorite: Bool) {
        self.movie = movie
        titleLabel.text = movie.title
        let posterURL = "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")"
        movieImageView.sd_setImage(with: URL(string: posterURL), placeholderImage: UIImage(systemName: "photo"))

        updateFavoriteStatus(isFavorite: isFavorite)
    }


    private func updateFavoriteStatus(isFavorite: Bool) {
        let starImage = isFavorite ? "star.fill" : "star"
        let starColor: UIColor = isFavorite ? .systemYellow : .gray

        favoriteButton.setImage(UIImage(systemName: starImage), for: .normal)
        favoriteButton.tintColor = starColor
    }

    @objc private func didTapFavoriteButton() {
        guard let movie = movie else { return }
        delegate?.didTapFavoriteButton(for: movie)
    }
}

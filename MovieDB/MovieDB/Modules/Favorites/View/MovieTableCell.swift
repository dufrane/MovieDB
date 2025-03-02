//
//  MovieTableCell.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 26.02.2025.
//

import UIKit
import SDWebImage

final class MovieTableCell: UITableViewCell {
    static let identifier = "MovieTableCell"

    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(movieImageView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            movieImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            movieImageView.widthAnchor.constraint(equalToConstant: 80),
            movieImageView.heightAnchor.constraint(equalToConstant: 120),

            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with favoriteMovie: FavoriteMovie) {
        titleLabel.text = favoriteMovie.title
        
        guard let posterPath = favoriteMovie.posterPath, !posterPath.isEmpty else {
            movieImageView.image = UIImage(systemName: "photo")
            return
        }

        let posterURL = "https://image.tmdb.org/t/p/w500\(posterPath)"
        movieImageView.sd_setImage(with: URL(string: posterURL), placeholderImage: UIImage(systemName: "photo"))
    }
}

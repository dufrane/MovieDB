//
//  ActorCell.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 25.02.2025.
//

import UIKit
import SDWebImage

final class ActorCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ActorCell"
    
    private let actorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(actorImageView)
        contentView.addSubview(nameLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            actorImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            actorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            actorImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            actorImageView.heightAnchor.constraint(equalToConstant: 120),
            
            nameLabel.topAnchor.constraint(equalTo: actorImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with actor: Actor) {
        nameLabel.text = actor.name
        let baseURL = "https://image.tmdb.org/t/p/w500"
        
        if let profilePath = actor.profile_path {
            let fullURL = URL(string: baseURL + profilePath)
            actorImageView.sd_setImage(with: fullURL, placeholderImage: UIImage(named: "placeholder"))
        } else {
            actorImageView.image = UIImage(named: "placeholder")
        }
    }
}


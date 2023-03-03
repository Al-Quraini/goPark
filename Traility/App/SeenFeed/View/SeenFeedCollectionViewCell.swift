//
//  SeenFeedCollectionViewCell.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/1/23.
//

import UIKit
import AVFoundation

class SeenFeedCollectionViewCell: UICollectionViewCell {
    static let id = "FeedCollectionViewCell"
//    
//    // TODO: Create Player View
//    var playerView : VideoPlayerView = {
//       let player = VideoPlayerView()
//        player.translatesAutoresizingMaskIntoConstraints = false
//        player.contentMode = .scaleAspectFill
//        player.isMuted = false
//
//        return player
//    }()
//    var placeHolder : UIImageView = {
//        let image = UIImageView()
//        image.translatesAutoresizingMaskIntoConstraints = false
//        image.contentMode = .scaleAspectFill
//        image.clipsToBounds = true
//        
//        return image
//    }()
//    var url: URL?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        NSLayoutConstraint.activate([
//            // Place holder constraints
//            placeHolder.topAnchor.constraint(equalTo: contentView.topAnchor),
//            placeHolder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            placeHolder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            placeHolder.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//
//            // player view constraints
//            playerView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            
//        ])
//    }
//    
//    func setup() {
//        self.contentView.clipsToBounds = true
//        self.contentView.addSubview(placeHolder)
//        self.contentView.addSubview(playerView)
//        self.contentView.backgroundColor = .white
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        resetCell()
//    }
//    
//    func set(url: URL) {
//        self.url = url
//    }
//    
//    func setPlaceHolder(data : Data) {
//        self.placeHolder.image = UIImage(data: data)
//    }
//    
//    
//    func play() {
//        playerView.isHidden = false
//        if let url = url {
//            playerView.play(for: url)
//        }
//    }
//    
//    func pause() {
//        playerView.isHidden = true
//        playerView.pause(reason: .hidden)
//        playerView.seek(to: CMTime.zero)
//    }
//    
//    func resetCell() {
//        playerView.isHidden = true
//        placeHolder.image = nil
//        url = nil
//    }
}

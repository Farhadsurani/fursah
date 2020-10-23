//
//  MerchantSliderVideoViewCell.swift
//  Fursahh
//
//  Created by Akber Sayni on 17/08/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class MerchantSliderVideoViewCell: UICollectionViewCell, YouTubePlayerDelegate {
    @IBOutlet weak var playerView: YouTubePlayerView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    public func setData(_ videoId: String) {
        self.activityIndicatorView.startAnimating()
        
        self.playerView.delegate = self
        self.playerView.playerVars = [
            "playsinline": "1",
            "controls": "1",
            "rel": "0"
            ] as YouTubePlayerView.YouTubePlayerParameters
        
        self.playerView.loadVideoID(videoId)
    }
    
    public func pauseVideo() {
        self.playerView.pause()
    }
    
    public func playVideo() {
        self.playerView.play()
    }
    
    public func stopVideo() {
        self.playerView.stop()
    }
    
    // MARK: - Youtube Player Delegate
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        self.activityIndicatorView.stopAnimating()
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        print("Player state changed")
    }
    
    func playerQualityChanged(_ videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
        print("Player quality changed")
    }
}

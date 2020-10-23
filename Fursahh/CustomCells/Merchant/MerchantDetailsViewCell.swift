//
//  MerchantDetailsViewCell.swift
//  Fursahh
//
//  Created by Akber Sayni on 08/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import ImageSlideshow

class MerchantDetailsViewCell: UITableViewCell {
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var videoLink: String?
    var bannerImages = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if let layout = self.sliderCollectionView.collectionViewLayout as? RTLCollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0.0
            layout.minimumInteritemSpacing = 0.0
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func updatePageControl() {
        if let cell = self.sliderCollectionView.visibleCells.last {
            if let indexPath = self.sliderCollectionView.indexPath(for: cell) {
                self.pageControl.currentPage = indexPath.row
                if indexPath.row < self.bannerImages.count {
                    self.pageControl.isHidden = false
                } else {
                    self.pageControl.isHidden = true
                }
            }
        }
    }
    
    func setData(_ data: MerchantModel?) {
        if let data = data {
            // Set banner images collection view
            if let images = data.bannerImages, images.count > 0 {
                //self.setImageSlider(banners)
                self.bannerImages = images
                self.pageControl.numberOfPages = images.count
            }
            
            // Set video link to the collection view
            if let video = data.videoLink, video.length > 0 {
                self.videoLink = video
                self.pageControl.numberOfPages = self.pageControl.numberOfPages + 1
            }
            
            self.sliderCollectionView.reloadData()
        }
    }
}

extension MerchantDetailsViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bannerImages.count + ((self.videoLink != nil) ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < self.bannerImages.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderImageCellIdentifier", for: indexPath) as! MerchantSliderImageViewCell
            cell.imageView.loadImage(self.bannerImages[indexPath.row], placeholderImage: UIImage(named: "placeholder"))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderVideoCellIdentifier", for: indexPath) as! MerchantSliderVideoViewCell
            cell.setData(self.videoLink!)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? MerchantSliderVideoViewCell {
            cell.pauseVideo()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updatePageControl()
    }
}

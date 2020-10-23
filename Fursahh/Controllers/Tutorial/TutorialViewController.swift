//
//  TutorialViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 13/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class TutorialViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var pages: [TutorialPageModel]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setTutorialPages()
        self.setPageControl()
    }
    
    private func setTutorialPages() {
        self.pages = Array<TutorialPageModel>()
        
        self.pages.append(TutorialPageModel("tutorial_first_message".localized, image: "tutorial-1"))
        self.pages.append(TutorialPageModel("tutorial_second_message".localized, image: "tutorial-2"))
    }
    
    private func setPageControl() {
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = 0
    }
    
    private func updatePageControl(_ indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
    
    @IBAction func onBtnAction(_ sender: AnyObject) {
        if let indexPath = Utility.getIndexPathForRow(collectionView, sender: sender) {
            if indexPath.row == (self.pages.count - 1) {
                // Last page finish button tappped
                self.showLoginViewController()
            } else {
                let scrollIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                self.collectionView.scrollToItem(at: scrollIndexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    // MARK: - Navigation
    
    private func showLoginViewController() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            as! LoginViewController
        
        controller.hero.isEnabled = true
        controller.hero.modalAnimationType = .auto
        
        self.heroReplaceViewController(with: controller)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension TutorialViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialPageCellIdentifier", for: indexPath)
            as! TutorialPageViewCell
        
        cell.setData(self.pages[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? TutorialPageViewCell {
            let title = (indexPath.row == self.pages.count - 1) ? "Finish".localized : "Next".localized
            cell.actionButton.setTitle(title, for: .normal)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cell = self.collectionView.visibleCells.first
        if let indexPath = self.collectionView.indexPath(for: cell!) {
            self.updatePageControl(indexPath)
        }
    }
}

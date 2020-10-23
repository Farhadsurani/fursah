//
//  HomeViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 07/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import ObjectMapper
import ImageSlideshow
import ESPullToRefresh

class HomeViewController: BaseViewController {
	@IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var topMerchantCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    @IBOutlet var merchantImageViews: [UIImageView]!
    
    var arrCategories: [CategoryModel]?
	var arrVouchers: [VoucherModel]?
	var arrNewMerchants: [MerchantModel]?
	var arrTopMerchants: [MerchantModel]?

	let network = NetworkManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.tabBarController?.delegate = self
        self.addTitleImage()
		self.network.reachability.whenUnreachable = { [weak self] reachability in
			self?.showOfflineViewController()
		}
		
		self.scrollView.es.addPullToRefresh {
			[unowned self] in
			/// Do anything you want...
			self.getHomeData()
		}

        self.updateCollectionFlowLayoutDirection(topMerchantCollectionView)
        self.updateCollectionFlowLayoutDirection(categoriesCollectionView)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getHomeData()
    }

	private func updateCollectionFlowLayoutDirection(_ sender: UICollectionView) {
		if let layout = sender.collectionViewLayout as? RTLCollectionViewFlowLayout {
			layout.scrollDirection = .horizontal
		}
	}

    private func setImageSliderDataSource() {
        self.slideShow.slideshowInterval = 5
        self.slideShow.contentScaleMode = .scaleAspectFill
        self.slideShow.activityIndicator = DefaultActivityIndicator()

        var inputSource = [AlamofireSource]()
        let images = self.arrVouchers!.map {$0.image ?? ""}
        
        for image in images {
            if let source = AlamofireSource(urlString: image) {
                inputSource.append(source)
            }
        }
            
        self.slideShow.setImageInputs(inputSource)
        
        // Add tap gesture
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onSlideShowTapGesture(_:)))
        self.slideShow.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setNewMerchantsView() {
        guard let merchants = self.arrNewMerchants else { return }
        
        for (index, elements) in merchants.enumerated() {
            if index >= self.merchantImageViews.count {
                return
            }
            
            let imageView = self.merchantImageViews[index]
            imageView.isHidden = false
            imageView.tag = index
            imageView.loadImage(elements.logoImage, placeholderImage: nil)
        }
    }
	
	// MARK: - IBAction Methods
	
    @IBAction func onBtnSearch(_ sender: AnyObject) {
        self.showSearchViewController()
    }
    
    @IBAction func onBtnViewAll(_ sender: AnyObject) {
        self.showMerchantListing()
    }
    
    @IBAction func onBtnImageSlideGesture(_ sender: AnyObject) {
        //self.showMerchantDetails()
    }
    
    @IBAction func onBtnMerchantImageGesture(_ sender: UITapGestureRecognizer) {
        if let merchants = self.arrNewMerchants {
            let index = sender.view?.tag ?? 0
            if index < merchants.count {
                self.showMerchantDetails(merchants[index].id)
            }
        }
    }
	
	@objc func onSlideShowTapGesture(_ sender: UITapGestureRecognizer) {
		if let voucher = self.arrVouchers?[self.slideShow.currentPage] {
			self.showMerchantDetails(voucher.merchantId)
		}
	}
	
	// MARK: - API Methods
	
	private func getHomeData() {
		Utility.showLoader()
		APIManager.sharedInstance.home.getHomeData(params: [:], success: { (response) in
			Utility.hideLoader()
			self.scrollView.es.stopPullToRefresh()
			if let brands = response["top_brands"] as? [[String: AnyObject]] {
				let array = Mapper<MerchantModel>().mapArray(JSONArray: brands)
				self.arrTopMerchants = array
			}
			
			if let categories = response["categories"] as? Array<[String: AnyObject]> {
				let array = Mapper<CategoryModel>().mapArray(JSONArray: categories)
				self.arrCategories = array
			}
			
			if let offers = response["offers"] as? Array<[String: AnyObject]> {
				let array = Mapper<VoucherModel>().mapArray(JSONArray: offers)
				self.arrVouchers = array
			}
			
			if let merchants = response["new_in_town"] as? Array<[String: AnyObject]> {
				let array = Mapper<MerchantModel>().mapArray(JSONArray: merchants)
				self.arrNewMerchants = array
			}
			
			self.setImageSliderDataSource()
			self.setNewMerchantsView()
			self.categoriesCollectionView.reloadData()
			self.topMerchantCollectionView.reloadData()
			
		}) { (error) in
			Utility.hideLoader()
			self.scrollView.es.stopPullToRefresh()
			Utility.showErrorAlert(message: error.localizedDescription)
		}
	}
    
    // MARK: - Navigation
    
    private func showMerchantListing(_ indexPath: IndexPath? = nil) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MerchantListViewController")
            as! MerchantListViewController
        
        if let indexPath = indexPath {
            controller.category = self.arrCategories![indexPath.row]
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showMerchantDetails(_ merchantId: String?) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MerchantDetailsViewController")
            as! MerchantDetailsViewController
        
        controller.merchantId = merchantId

        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showSearchViewController() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController")
            as! SearchViewController
        
        self.navigationController?.pushViewController(controller, animated: true)        
    }
	
    // In a storyboard-based application, you will often want to do a little preparation before navigation
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.topMerchantCollectionView {
            return self.arrTopMerchants?.count ?? 0
        } else {
            return self.arrCategories?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.topMerchantCollectionView {
            return self.getMerchantLogoViewCell(indexPath, collectionView: collectionView)
        } else {
            return self.getCategoryViewCell(indexPath, collectionView: collectionView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.topMerchantCollectionView {
            let height = collectionView.frame.size.height
            return CGSize(width: height + (height * 0.5), height: height)
        } else {
            let height = collectionView.frame.size.height
            return CGSize(width: height * 0.75, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.topMerchantCollectionView {
            self.showMerchantDetails(self.arrTopMerchants![indexPath.row].id)
        } else {
            self.showMerchantListing(indexPath)
        }
    }
        
    // MARK: - Helper Methods
    
    private func getMerchantLogoViewCell(_ indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MerchantLogoCellIdentifier", for: indexPath)
            as! MerchantLogoViewCell
        
        cell.setData(self.arrTopMerchants![indexPath.row])
        
        return cell
    }
    
    private func getCategoryViewCell(_ indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCellIdentifier", for: indexPath)
            as! CategoryViewCell
        
        cell.setData(self.arrCategories![indexPath.row])
        
        return cell
    }
}

extension HomeViewController: UITabBarControllerDelegate {
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		if (AppStateManager.shared.isUserLoggedIn()) {
			return true
		}
		
		if let navigation = viewController as? UINavigationController {
			if let controller = navigation.viewControllers.first {
				if controller.isKind(of: FavoriteMerchantsViewController.self)
					|| controller.isKind(of: ProfileViewController.self)
					|| controller.isKind(of: NotificationsListViewController.self) {
					
					// Show login popup
					Constants.APP_DELEGATE.showLoginViewController()
					return false
				}
			}
		}
		
		return true
	}
}


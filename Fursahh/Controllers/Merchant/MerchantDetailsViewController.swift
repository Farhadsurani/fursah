//
//  MerchantDetailsViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 08/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import ObjectMapper
import ImageSlideshow
import FacebookCore

class MerchantDetailsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoriteBarItem: UIBarButtonItem!
    @IBOutlet weak var directionBarButtonItem: UIBarButtonItem!
    
    var merchantId: String?
	var arrVouchers: [VoucherModel]?
	var selectedBranch: BranchModel?
    var merchantDetails: MerchantModel?
	var isLoadedView = false
	
	let network = NetworkManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
		self.network.reachability.whenUnreachable = { [weak self] reachability in
			self?.showOfflineViewController()
		}
        
        //self.setNavigationRightItems()
        self.logViewContentEvent(contentType: "product", contentData: self.merchantDetails?.name ?? "", contentId: "", currency: "OMR", price: 0.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMerchantDetails(self.merchantId)
    }

    private func setNavigationTitle() {
        if Locale.current.languageCode == "ar" {
            self.navigationItem.title = self.merchantDetails?.nameAR ?? self.merchantDetails?.name ?? "-"
        } else {
            self.navigationItem.title = self.merchantDetails?.name ?? "-"
        }
    }
    
    private func setNavigationRightItems() {
        self.favoriteBarItem.width = 30
        self.directionBarButtonItem.width = 30
        //let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //spaceItem.width = 40;
        self.navigationItem.rightBarButtonItems = [favoriteBarItem, directionBarButtonItem]
    }
    
    private func setFavoriteIcon() {
        if let merchant = self.merchantDetails, merchant.isFavorite == 1 {
            let image = UIImage(named: "icon_list_favorite_selected")
            self.favoriteBarItem.image = image
        } else {
            let image = UIImage(named: "icon_list_favorite")
            self.favoriteBarItem.image = image
        }
    }
    
    private func setDefaultBranch() {
        if let branches = self.merchantDetails?.branches, branches.count > 0 {
            self.selectedBranch = branches.first
            self.getMerchantOffers(self.merchantDetails?.id, branchId: self.selectedBranch?.id)
        }
    }
	
	private func redeemVoucher(_ indexPath: IndexPath) {
		guard AppStateManager.shared.isUserLoggedIn() else {
			Constants.APP_DELEGATE.showLoginViewController()
			return
		}
		
		let voucher = self.arrVouchers![indexPath.row]
		
		// Offer is already redeemed
		if let redeemed = voucher.isRedeemed, redeemed.lowercased().contains("yes") {
			print("Offer already redeemed")
			return
		}
		
		// Check offer count
		if let isLimited = voucher.isLimited, isLimited.lowercased().contains("yes") {
			if voucher.count == "0" {
				Utility.showMessageAlert(message: "Offer not available".localized)
				return
			}
		}
		
		// Offer is valid for the selected branch
		if voucher.isValid == 0 {
			if let branches = self.merchantDetails?.branches, branches.count > 1 {
				self.showInvalidOutletPopup(indexPath)
			} else {
				Utility.showMessageAlert(message: "invalid_outlet_message".localized)
			}
			
			return
		}

		
		self.showOfferDetails(indexPath)
	}
    
    private func showOfferDetails(_ indexPath: IndexPath) {
        if let branches = self.merchantDetails?.branches, branches.count > 1 {
            self.showOfferDetailsPopup(indexPath)
        } else {
            self.showMerchantPinCodePopup(self.arrVouchers![indexPath.row])
        }
    }
	
	private func showDirectionOnMap(latitude: String, longitude: String) {
		if let googleMapsURL = URL(string: "comgooglemaps://") {
			if UIApplication.shared.canOpenURL(googleMapsURL) {
				let url = URL(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")
				UIApplication.shared.open(url!, options: [:], completionHandler: nil)
			} else {
				Utility.showMessageAlert(message: "google_maps_not_available".localized)
			}
		}
	}
    
    private func logViewContentEvent(contentType : String, contentData : String, contentId : String, currency : String, price : Double) {
        let params : AppEvent.ParametersDictionary = [
            .contentType : contentType,
            .content : contentData,
            .contentId : contentId,
            .currency : currency
        ]
        let event = AppEvent(name: .viewedContent, parameters: params, valueToSum: price)
        AppEventsLogger.log(event)
    }
    
    private func logAddToWishlistEvent(contentData : String, contentId : String, contentType : String, currency : String, price : Double) {
        let params : AppEvent.ParametersDictionary = [
            .content : contentData,
            .contentId : contentId,
            .contentType : contentType,
            .currency : currency
        ]
        let event = AppEvent(name: .addedToWishlist, parameters: params, valueToSum: price)
        AppEventsLogger.log(event)
    }
	
	// MARK: - IBAction Methods
    
    @IBAction func onBtnAddFavorite(_ sender: AnyObject) {
        guard self.merchantDetails != nil else { return }
		
		if AppStateManager.shared.isUserLoggedIn() {
			let isFavorite = self.merchantDetails!.isFavorite == 0 ? true: false
			self.addMerchantFavorite(isFavorite)
		} else {
			Constants.APP_DELEGATE.showLoginViewController()
		}
    }
    
    @IBAction func onLocationTapGesture(_ sender: UITapGestureRecognizer) {
        self.showBranchListPopup()
    }
    
    @IBAction func onContactTapGesture(_ sender: UITapGestureRecognizer) {
        guard let phoneNo = self.selectedBranch?.phoneNo, phoneNo.length > 0 else {
            Utility.showMessageAlert(message: "phone_not_provided".localized)
            return
        }
        
        self.showPhoneDialer(phoneNo)
    }
    
    @IBAction func onInstagramTapGesture(_ sender: UITapGestureRecognizer) {
        guard let instagram = self.merchantDetails?.instagram, instagram.length > 0 else {
            Utility.showMessageAlert(message: "instagram_not_available".localized)
            return
        }

        self.showInstagramAccount(instagram)
    }

    @IBAction func onMenuTapGesture(_ sender: UITapGestureRecognizer) {
        guard let urlString = self.merchantDetails?.pdfMenu, urlString.length > 0 else {
            Utility.showMessageAlert(message: "pdf_not_provided".localized)
            return
        }
        
        self.showPDFViewer(urlString)
    }
    
    @IBAction func onBtnDirection(_ sender: AnyObject) {
        if let latitude = self.selectedBranch?.latitude, let longitude = self.selectedBranch?.longitude {
            self.showDirectionOnMap(latitude: latitude, longitude: longitude)
        } else {
            Utility.showMessageAlert(message: "location_not_found".localized)
        }
    }
    
    // MARK: - Web API Methods
    
    private func getMerchantDetails(_ merchantId: String?) {
        Utility.showLoader()
        let params: [String: Any] = [
            "merchant_id": merchantId ?? "",
            "user_id": AppStateManager.shared.getUserId() ?? "0",
            "lat": Constants.APP_DELEGATE.location?.coordinate.latitude ?? 0.0,
            "long": Constants.APP_DELEGATE.location?.coordinate.longitude ?? 0.0
        ]
        APIManager.sharedInstance.merchant.getMerchantDetails(params: params, success: { (response) in
            //Utility.hideLoader()
            self.merchantDetails = Mapper<MerchantModel>().map(JSON: response)
            self.setNavigationTitle()
            self.setFavoriteIcon()
            self.setDefaultBranch()
            self.tableView.reloadData()
        }) { (error) in
            Utility.hideLoader()
            Utility.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    private func getMerchantOffers(_ merchantId: String?, branchId: String?) {
        Utility.showLoader()
        let params: [String: Any] = [
            "user_id": AppStateManager.shared.getUserId() ?? "0",
            "merchant_id": merchantId ?? "",
            "branch_id": branchId ?? ""
        ]
        APIManager.sharedInstance.merchant.getMerchantOffers(params: params, success: { (responseArray) in
            Utility.hideLoader()
            let vouchers = Mapper<VoucherModel>().mapArray(JSONArray: responseArray as! [[String : Any]])
			if self.isLoadedView == false {
				if (self.merchantDetails?.branches?.count ?? 0) > 1 {
					self.showBranchListPopup()
				}
				self.isLoadedView = true
			}
            //self.arrVouchers = vouchers
            self.arrVouchers = vouchers.filter { $0.isValid == 1 }
            self.tableView.reloadData()
        }) { (error) in
            Utility.hideLoader()
            Utility.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    private func addMerchantFavorite(_ isFavorite: Bool) {
        Utility.showLoader()
        let params: [String: Any] = [
            "user_id": AppStateManager.shared.getUserId() ?? "0",
            "merchant_id": self.merchantDetails?.id ?? "",
            "is_favorite": isFavorite ? "1" : "0"
        ]
        APIManager.sharedInstance.merchant.addMerchantFavorite(params: params, success: { (success) in
            Utility.hideLoader()
            self.setFavoriteIcon()
            if isFavorite {
                self.merchantDetails?.isFavorite = 1
                Utility.showMessageAlert(message: "merchant_added_success".localized)
                self.logAddToWishlistEvent(contentData: self.merchantDetails?.name ?? "", contentId: "", contentType: "product", currency: "OMR", price: 0.0)
            } else {
                self.merchantDetails?.isFavorite = 0
                Utility.showMessageAlert(message: "merchant_removed_success".localized)
            }
        }) { (error) in
            Utility.hideLoader()
            Utility.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    // MARK: - Navigation
	
    private func showOfferDetailsPopup(_ indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmationPopupViewController")
            as! ConfirmationPopupViewController
        
        controller.delegate = self
        controller.branch = self.selectedBranch
        controller.voucherDetails = self.arrVouchers![indexPath.row]
        controller.modalPresentationStyle = .overCurrentContext
        
        self.present(controller, animated: false, completion: nil)
    }
	
	private func showInvalidOutletPopup(_ indexPath: IndexPath) {
		let controller = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmationPopupViewController")
			as! ConfirmationPopupViewController
		
		controller.type = .invalidOutlet
		controller.delegate = self
		controller.branch = self.selectedBranch
		controller.voucherDetails = self.arrVouchers![indexPath.row]
		controller.modalPresentationStyle = .overCurrentContext

		self.present(controller, animated: false, completion: nil)
	}
    
    private func showBranchListPopup() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ListPopupViewController")
            as! ListPopupViewController
        
        controller.delegate = self
        controller.arrBranches = self.merchantDetails?.branches
        controller.selectedBranch = self.selectedBranch
        
        controller.modalPresentationStyle = .overCurrentContext
        
        self.present(controller, animated: false, completion: nil)
    }
    
    private func showMerchantPinCodePopup(_ voucher: VoucherModel?) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MerchantPinCodeViewController")
            as! MerchantPinCodeViewController
        
        controller.voucherDetails = voucher
        controller.branchId = self.selectedBranch?.id

        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showPDFViewer(_ urlString: String) {
        let controller = PDFViewController()
        
        controller.urlString = urlString
        controller.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(controller, animated: true)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension MerchantDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return self.arrVouchers?.count ?? 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantDetailsCellIdentifier", for: indexPath) as! MerchantDetailsViewCell
            cell.setData(self.merchantDetails)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOutletDetailsCellIdentifier", for: indexPath) as! MerchantOutletDetailsViewCell
            cell.setData(self.merchantDetails, branch: self.selectedBranch)
            return cell
        case 2:
            let voucher = self.arrVouchers![indexPath.row]
            if let isRedeemed = voucher.isRedeemed, isRedeemed.lowercased().contains("yes") {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OfferRedeemedCellIdentifier", for: indexPath) as! OfferListViewCell
                cell.setRedeemedData(voucher)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OfferCellIdentifier", for: indexPath) as! OfferListViewCell
                cell.setData(voucher)
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 40.0
        }
        
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40.0))
            view.backgroundColor = .white
            
            let label = UILabel(frame: CGRect(x: 20.0, y: 0, width: view.frame.size.width - 40.0, height: view.frame.size.height))
            label.text = "Discount Offers".localized
            
            view.addSubview(label)
            
            return view
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.async {
            if indexPath.section == 2 {
				self.redeemVoucher(indexPath)
            }
        }
    }
}

extension MerchantDetailsViewController: ConfirmationPopupDelegate {
    func didTapChangeOutletButton() {
        // Show outlet list
        self.showBranchListPopup()
    }
	
	func didTapCancelButton() {
		// Do nothing
	}
    
    func didTapContinueButton(_ voucher: VoucherModel?) {
        // Continue redeem
        self.showMerchantPinCodePopup(voucher)
    }
}

extension MerchantDetailsViewController: ListPopupDelegate {
    func didSelectBranch(_ branch: BranchModel) {
        self.selectedBranch = branch
        self.getMerchantOffers(self.merchantDetails?.id, branchId: self.selectedBranch?.id)
    }
}

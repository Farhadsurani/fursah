//
//  ListPopupViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 13/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

protocol ListPopupDelegate {
    func didSelectBranch(_ branch: BranchModel)
}

class ListPopupViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.tableFooterView = UIView()
        }
    }
    
    var delegate: ListPopupDelegate?

    var arrBranches: [BranchModel]?
    var selectedBranch: BranchModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func onSelectBranch(_ indexPath: IndexPath) {
        self.dismiss(animated: true) {
            if self.delegate != nil {
                self.delegate?.didSelectBranch(self.arrBranches![indexPath.row])
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ListPopupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrBranches?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListPopupCellIdentifier", for: indexPath)
        
        let branch = self.arrBranches![indexPath.row]
        
        if Locale.current.languageCode == "ar" {
            cell.textLabel?.text = branch.nameAR ?? branch.name ?? "-"
            cell.detailTextLabel?.text = branch.location ?? "-"
        } else {
            cell.textLabel?.text = branch.name ?? "-"
            cell.detailTextLabel?.text = branch.location ?? "-"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessoryType = .none

        if let selectedBranch = self.selectedBranch {
            let branch = self.arrBranches![indexPath.row]
            if branch.id == selectedBranch.id {
                cell.accessoryType = .checkmark
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.onSelectBranch(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

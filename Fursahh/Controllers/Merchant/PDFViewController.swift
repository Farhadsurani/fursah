//
//  PDFViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 16/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: BaseViewController {
    
    var urlString: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Add PDFView to view controller.
        let pdfView = PDFView(frame: self.view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(pdfView)
        
        // Fit content in PDFView.
        pdfView.autoScales = false
        
        // Load Sample.pdf file from app bundle.
        guard let pdfURL = URL(string: urlString!) else {
            Utility.showMessageAlert(message: "failed_load_pdf".localized)
            return
        }
        
        pdfView.document = PDFDocument(url: pdfURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

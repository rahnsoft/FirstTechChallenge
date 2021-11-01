//
//  WebViewController.swift
//  MakeupApp
//
//  Created by IOS DEV PRO 1 on 07/10/2021.
//  Copyright © 2021 LTD. All rights reserved.
//

import Foundation
import PDFKit
import UIKit

final class WebViewController: UIViewController {
    let coverImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "image-copyright").withRenderingMode(.alwaysOriginal)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let label: UILabel = {
        let l = UILabel()
        l.textColor = .textColor
        l.numberOfLines = .zero
        l.textAlignment = .center
        l.contentMode = .scaleToFill
        l.text = "Materials and libraries used for the development of this application are for educational purposes only, and should not be distributed or made public without the author's authorisation.\nSpecial acknowledgement to the authors of the libraries that came into play during the development cycle of this app.\n\n© Collins Kiplimo 2021.\n\nABOUT"
        l.font = UIFont.appSemiBoldFont(ofSize: HavaConstants.DEFAULT_FONT_SIZE - 1)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var pdfView: PDFView = {
        let v = PDFView()
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        v.autoScales = true
        v.displayBox = .artBox
        v.displayMode = .singlePageContinuous
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private var urlPT = URL(string: HavaConstants.aboutUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.keyWindow?.startBlockingActivityIndicator()
        DispatchQueue.main.async {
            self.pdfView.document = PDFDocument(url: self.urlPT!)
            UIApplication.shared.keyWindow?.stopBlockingActivityIndicator()
        }
        setupTitleAndRightButtonView(title: "Copyright", isProfile: false)
        setupTitleAndBackButtonView(title: "Back", isBackButton: true, isBackAnimation: false)
        setupViews()
    }

    fileprivate func setupViews() {
        let containerView = UIView()
        view.backgroundColor = .white
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        view.addSubview(pdfView)
        containerView.addSubview(label)
        containerView.addSubview(coverImage)

        containerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: pdfView.topAnchor).isActive = true

        let height = UIScreen.main.bounds.height / 10
        coverImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        coverImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        coverImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
        coverImage.heightAnchor.constraint(equalToConstant: height).isActive = true
        coverImage.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true

        label.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        pdfView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
}

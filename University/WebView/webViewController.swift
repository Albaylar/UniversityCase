//
//  webViewController.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 26.04.2024.
//

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController {
    let webView = WKWebView()
    let backButton = UIButton()
    let universityLabel = UILabel()
    let universityName: String

    init(url: URL, universityName: String) {
            self.universityName = universityName
            super.init(nibName: nil, bundle: nil)
            webView.load(URLRequest(url: url))
        }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        let topView = UIView()
        topView.backgroundColor = .white
        view.addSubview(topView)
        
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.left.equalToSuperview()
            make.height.equalTo(50)
        }
        
        topView.clipsToBounds = true
        topView.layer.cornerRadius = 2
        topView.layer.borderWidth = 4
        
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        topView.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        universityLabel.font = UIFont.boldSystemFont(ofSize: 24)
        universityLabel.textColor =  .black
        universityLabel.text = universityName

        topView.addSubview(universityLabel)
        
        universityLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }
}


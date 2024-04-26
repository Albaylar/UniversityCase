//
//  UniversityDetailCell.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 25.04.2024.
//

import UIKit

protocol UniversityDetailCellDelegate: AnyObject {
    func presentWebViewController(_ viewController: UIViewController)
}


class UniversityDetailCell: UITableViewCell {
    
    private let view = UIView()
    private let viewLabel = UILabel()
    private var university: University?
    private var dataType = UniversityDataType.phone
    weak var delegate : UniversityDetailCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI() {
        
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).inset(5)
            make.top.equalToSuperview().offset(5)
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(60)
        }
        
        view.addSubview(viewLabel)
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.black.cgColor
        
        view.layer.masksToBounds = true
        viewLabel.numberOfLines = 0
        viewLabel.snp.makeConstraints { make in
               make.top.equalToSuperview().offset(5)
               make.bottom.equalToSuperview().inset(5)
               make.left.equalToSuperview().inset(10)
                make.right.equalToSuperview().inset(20)
           }
        
        setupGestureRecognizer()
    }
    
    func configure(with universityData: University?, dataType: UniversityDataType, delegate : UniversityDetailCellDelegate) {
        self.delegate = delegate
        
        let dataTypeString = dataType.rawValue + ": "
        self.university = universityData
        switch dataType {
        case .fax:
            viewLabel.text = dataTypeString + (university?.fax ?? "")
        case .phone:
            viewLabel.text = dataTypeString + (university?.phone ?? "")
        case .website:
            viewLabel.text = dataTypeString + (university?.website ?? "")
        case .adress:
            viewLabel.text = dataTypeString + (university?.adress ?? "")
        case .rector:
            viewLabel.text = dataTypeString + (university?.rector ?? "")
        }
        
        self.dataType = dataType
    }
    func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openWebsite))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    
    @objc func openWebsite() {
        if let websiteURLString = university?.website,
           let websiteURL = URL(string: websiteURLString),
           dataType == .website  {
            let webViewController = WebViewController(url: websiteURL, universityName: university?.name ?? "")
            webViewController.modalPresentationStyle = .fullScreen
            delegate?.presentWebViewController(webViewController)
        } else if let phoneNumberString = university?.phone, let url = URL(string: "tel://\(phoneNumberString)"), dataType == .phone {
            UIApplication.shared.open(url)
        }
    }
}

enum UniversityDataType: String, CaseIterable {
    case fax, phone, website, adress, rector
}

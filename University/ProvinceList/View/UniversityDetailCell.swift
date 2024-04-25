//
//  UniversityDetailCell.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 25.04.2024.
//

import UIKit



class UniversityDetailCell: UITableViewCell {
    
    private let view = UIView()
    private let viewLabel = UILabel()
    private var university: University?
    private var dataType = UniversityDataType.phone
    weak var delegate : UniversityHeaderViewDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.right.left.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
        }
        view.addSubview(viewLabel)
        viewLabel.numberOfLines = 0
        viewLabel.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(5)
            make.top.bottom.equalToSuperview().inset(5)
            make.height.equalTo(30)
        }
       
    }
    
    
    func configure(with universityData: University?, dataType: UniversityDataType, delegate : UniversityHeaderViewDelegate) {
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

}

enum UniversityDataType: String, CaseIterable {
    case fax, phone, website, adress, rector
}

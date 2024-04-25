//
//  UniversityListTableViewCell.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 23.04.2024.
//

import UIKit

class UniversityListTableViewCell: UITableViewCell {
    // Üniversite adını gösterecek UILabel
    let universityNameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        universityNameLabel.font = UIFont.systemFont(ofSize: 16)
        universityNameLabel.textColor = UIColor.black
        
        contentView.addSubview(universityNameLabel)
        universityNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.left.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
        
    }
    
    func configure(with university: University) {
        universityNameLabel.text = university.name
    }

}


//
//  FavoritesCell.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 3.05.2024.
//

import UIKit


class FavoritesCell: UITableViewCell {
    
    private var datum: Datum?
    private var university: University?
    
    private let plusminusButton = UIButton()
    private var universityNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews() {
        contentView.addSubview(universityNameLabel)
        contentView.addSubview(plusminusButton)
        plusminusButton.addTarget(self, action: #selector(plusMinusButtonTapped), for: .touchUpInside)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.masksToBounds = true
        
        plusminusButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        universityNameLabel.snp.makeConstraints { make in
            make.top.equalTo(universityNameLabel.snp.bottom).offset(4)
            make.left.equalTo(plusminusButton.snp.right).offset(16)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }
        
        updatePlusMinusButtonAppearance()
        plusminusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusminusButton.tintColor = .black
    }
    
    @objc internal func plusMinusButtonTapped() {
        var isExpanded = datum?.isExpanded ??  false
        isExpanded.toggle()
        updatePlusMinusButtonAppearance()
        guard var datum else {  return }
        datum.isExpanded = isExpanded
        
        
    }
    
    private func updatePlusMinusButtonAppearance() {
        guard let isExpanded = datum?.isExpanded else { return }
        let imageName = isExpanded ? "minus" : "plus"
        plusminusButton.setImage(UIImage(systemName: imageName), for: .normal)
        
    }
    
    func configure(university: University) {
        self.university = university
        universityNameLabel.text = university.name
        
    }
}

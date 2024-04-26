//
//  UniversityCell.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 18.04.2024.
//

import UIKit
import SnapKit

protocol ProvinceCellDelegate: AnyObject {
    func plusMinusButtonTapped(for datum: Datum)
}

final class ProvinceCell: UITableViewHeaderFooterView {
    private var university: University?

    private var datum: Datum?
    private let plusminusButton = UIButton()
    private let universityNameLabel = UILabel()
    private let provinceLabel = UILabel()
    private weak var delegate: ProvinceCellDelegate?
    

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    private func setupViews() {
        contentView.addSubview(universityNameLabel)
        contentView.addSubview(provinceLabel)
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
        
        provinceLabel.snp.makeConstraints { make in
            make.top.equalTo(universityNameLabel.snp.bottom).offset(4)
            make.left.equalTo(plusminusButton.snp.right).offset(16)
            make.bottom.equalToSuperview().offset(-10)
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
        delegate?.plusMinusButtonTapped(for: datum)
        
    }
    
    private func updatePlusMinusButtonAppearance() {
        guard let isExpanded = datum?.isExpanded else { return }
        let imageName = isExpanded ? "minus" : "plus"
        plusminusButton.setImage(UIImage(systemName: imageName), for: .normal)
      
    }
    
    func configure(with datum : Datum, delegate: ProvinceCellDelegate) {
        self.delegate = delegate
        self.datum = datum
     //   universityNameLabel.text = university?.name
        provinceLabel.text = datum.province
        plusminusButton.setImage(UIImage(systemName: (datum.isExpanded ?? false) ? "minus" : "plus"), for: .normal)
    }
    
}

extension ProvinceCell : UniversityHeaderViewDelegate {
    func favoriteStatusChanged(for university: University, isFavorite: Bool) {
        
    }
    
    func favoriteButtonTapped(for university: University, isFavorite: Bool) {
        
    }
    
    func presentWebViewController(_ viewController: UIViewController) {
        
    }
    
    func plusMinusButtonClicked(for university: University) {
        
    }
 
    
    
    
}












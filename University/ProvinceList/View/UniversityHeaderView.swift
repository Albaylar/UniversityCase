//
//  SubCell.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 24.04.2024.
//

import UIKit

protocol UniversityHeaderViewDelegate: AnyObject {
    func favoriteButtonTapped()
    func plusMinusButtonClicked(for university : University)
}

class UniversityHeaderView: UITableViewHeaderFooterView {
    
    var university: University?
    let universityNameLabel = UILabel()
    let plusMinusButton = UIButton()
    let favoriteButton = UIButton()
    let view = UIView()
    var isFavorite: Bool = false
  //  var universities : University
    private weak var delegate : UniversityHeaderViewDelegate?
    private let tableView = UITableView()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        university = nil
        universityNameLabel.text = nil
    }

    private func setupViews() {
        
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant:  10),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.masksToBounds = true

        // Plus-Minus Button
        
        view.addSubview(plusMinusButton)
        plusMinusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusMinusButton.addTarget(self, action: #selector(plusMinusButtonTapped), for: .touchUpInside)
        plusMinusButton.tintColor = .black
        plusMinusButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(40)
            
        }

        // Favorite Button
        view.addSubview(favoriteButton)
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .systemRed
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        view.addSubview(universityNameLabel)
        // University Name Label
        universityNameLabel.snp.makeConstraints { make in
            make.left.equalTo(plusMinusButton.snp.right).offset(10)
            make.right.equalTo(favoriteButton.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    func setupTableViews(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func plusMinusButtonTapped() {
        guard var university else { return }
        university.isExpanded = !(university.isExpanded ?? false)
        updatePlusMinusButtonAppearance()
        delegate?.plusMinusButtonClicked(for: university)
    }
    
    @objc private func favoriteButtonTapped() {
        isFavorite.toggle()
        updateFavoriteButtonAppearance()
        delegate?.favoriteButtonTapped()
    }
    
    private func updatePlusMinusButtonAppearance() {
        let imageName = (university?.isExpanded ?? false) ? "minus" : "plus"
        plusMinusButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func updateFavoriteButtonAppearance() {
        let imageName = (university?.isExpanded ?? false) ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    func configure(with university: University?, hasSingleUniversity: Bool, delegate: UniversityHeaderViewDelegate) {
        self.delegate = delegate
        self.university = university
        universityNameLabel.text = university?.name
    }
    
}

extension UniversityHeaderView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FooterTableViewCell", for: indexPath) as! UniversityCell
        
        return cell
    }
    
    
}




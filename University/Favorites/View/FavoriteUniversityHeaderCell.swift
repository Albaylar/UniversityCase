//
//  FavoriteUniversityHeaderCell.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 21.05.2024.
//

import UIKit

protocol FavoriteUniversityHeaderCellDelegate: AnyObject {
    func plusMinusButtonClicked(for university: University)
    func updateTableView()
}

class FavoriteUniversityHeaderCell: UITableViewHeaderFooterView {
    
    var university: University?
    let universityNameLabel = UILabel()
    let plusMinusButton = UIButton()
    let favoriteButton = UIButton()
    let view = UIView()
    var isFavorite: Bool? = false
    private weak var delegate : FavoriteUniversityHeaderCellDelegate?
    private let tableView = UITableView()
    private let viewModel = UniversityViewModel()
    
    
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
        plusMinusButton.setImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    private func setupViews() {
        
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
        }
        
        
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
        guard var university = university else { return }
        university.isExpanded = !(university.isExpanded ?? false)
        updatePlusMinusButtonAppearance()
        delegate?.plusMinusButtonClicked(for: university)
    }
    
    private func updatePlusMinusButtonAppearance() {
        if let name = university?.name,
           let fax = university?.fax ,
           let website = university?.website,
           let adress = university?.adress,
           let rector = university?.rector,
           fax != "-",website != "-", adress != "-", rector != "-"{
            plusMinusButton.isHidden = false
        } else {
            plusMinusButton.isHidden = true
        }
        
        let imageName = (university?.isExpanded ?? false) ? "minus" : "plus"
        plusMinusButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func favoriteButtonTapped() {
        guard let university = university ,
              let name = university.name else { return }
        FavoriteManager.shared.favorites.contains(where: {$0.name == name}) ? FavoriteManager.shared.removeFromFavorites(university: university ) : FavoriteManager.shared.addNewFavorite(university: university)
        isFavorite?.toggle()
        updateFavoriteButtonAppearance()
        delegate?.updateTableView()
    }
    
    private func updateFavoriteButtonAppearance() {
        let imageName = (isFavorite ?? false) ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func configure(with university: University?,
                   hasSingleUniversity: Bool,
                   isfav: Bool,
                   delegate: FavoriteUniversityHeaderCellDelegate) {
        self.delegate = delegate
        self.university = university
        universityNameLabel.text = university?.name
        self.isFavorite = isfav
        updateFavoriteButtonAppearance()
        updatePlusMinusButtonAppearance()
    }
}

extension FavoriteUniversityHeaderCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.universities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesCell
        return cell
    }
    
    
}





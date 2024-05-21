//
//  FavoritesViewController.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 26.04.2024.
//


import UIKit
import CoreData

final class FavoritesViewController: UIViewController {
    
    let backButton = UIButton()
    let titleLabel = UILabel()
    let tableView = UITableView()
    let noFavoritesLabel = UILabel()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func setupUI() {
        view.backgroundColor = .white
        tableView.register(UniversityHeaderView.self, forHeaderFooterViewReuseIdentifier: UniversityHeaderView.identifier)
        tableView.register(UniversityDetailCell.self, forCellReuseIdentifier: UniversityDetailCell.identifier)


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

        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        titleLabel.text = "Favorites"

        topView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoritesCell.self, forCellReuseIdentifier: "FavoritesCell")
        tableView.register(FavoriteUniversityHeaderCell.self, forHeaderFooterViewReuseIdentifier: FavoriteUniversityHeaderCell.identifier)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
        view.addSubview(noFavoritesLabel)
        noFavoritesLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
    }

    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }
    
    func fetchFavoriteUniversities() {
        //FavoriteManager.shared.fetchData() 
        tableView.reloadData()
        
        if FavoriteManager.shared.favorites.isEmpty {
            noFavoritesLabel.text = "Henüz favorilere üniversite eklenmedi."
            noFavoritesLabel.textColor = .black
            noFavoritesLabel.textAlignment = .center
            noFavoritesLabel.font = UIFont.systemFont(ofSize: 16)
            tableView.backgroundView = noFavoritesLabel
        } else {
            tableView.backgroundView = nil
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (FavoriteManager.shared.favorites[section].isExpanded ?? false) ? UniversityDataType.allCases.count : 0
            }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        FavoriteManager.shared.favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UniversityDetailCell.identifier, for: indexPath) as! UniversityDetailCell
        cell.configure(with: FavoriteManager.shared.favorites[indexPath.section], dataType: UniversityDataType.allCases[indexPath.row], delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let universityToDelete = FavoriteManager.shared.favorites[indexPath.row]
            FavoriteManager.shared.removeFromFavorites(university: universityToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if FavoriteManager.shared.favorites.isEmpty {
                noFavoritesLabel.isHidden = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FavoriteUniversityHeaderCell.identifier) as! FavoriteUniversityHeaderCell
       let university = FavoriteManager.shared.favorites[section]
        header.configure(with: university, hasSingleUniversity: true , isfav: true, delegate: self)
        return header

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

}

extension FavoritesViewController: FavoriteUniversityHeaderCellDelegate {
    func plusMinusButtonClicked(for university: University) {
        for i in FavoriteManager.shared.favorites.indices {
            FavoriteManager.shared.favorites[i].isExpanded = false
            if FavoriteManager.shared.favorites[i].name == university.name {
                FavoriteManager.shared.favorites[i].isExpanded = university.isExpanded
            }
        }
        tableView.reloadData()
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
    
}

extension FavoritesViewController: UniversityDetailCellDelegate {
    func presentWebViewController(_ viewController: UIViewController) {
        
    }
}

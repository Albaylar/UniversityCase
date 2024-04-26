//
//  FavoritesViewController.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 26.04.2024.
//


import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    let backButton = UIButton()
    let titleLabel = UILabel()
    let tableView = UITableView()
    let noFavoritesLabel = UILabel()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchFavoriteUniversities()
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        FavoriteManager.shared.favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let university = FavoriteManager.shared.favorites[indexPath.row]
        cell.textLabel?.text = university
        cell.contentView.layer.cornerRadius = 3
        cell.contentView.layer.borderWidth = 4
        
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let universityToDelete = FavoriteManager.shared.favorites[indexPath.row]
            FavoriteManager.shared.removeFromFavorites(name: universityToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if FavoriteManager.shared.favorites.isEmpty {
                noFavoritesLabel.isHidden = false
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }


}




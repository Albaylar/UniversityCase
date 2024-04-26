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
    var favoriteUniversities: [FavoriteUniversity] = [] // Değişiklik burada

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
            make.left.right.bottom.equalToSuperview()
        }
    }

    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }
    
    func fetchFavoriteUniversities() {
        favoriteUniversities = CoreDataManager.shared.fetchFavoriteUniversities()
        tableView.reloadData()
    }

}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteUniversities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let university = favoriteUniversities[indexPath.row]
        cell.textLabel?.text = university.name
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Silinecek favori üniversiteyi al
            let universityToDelete = favoriteUniversities[indexPath.row].name
            
            // Core Data'dan sil
            CoreDataManager.shared.deleteFavoriteUniversity(with: universityToDelete)
            
            // Favori üniversiteler dizisinden de sil
            favoriteUniversities.remove(at: indexPath.row)
            
            // TableView'daki satırı güncelle
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


}



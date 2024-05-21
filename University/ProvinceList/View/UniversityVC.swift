//
//  ViewController.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 2.04.2024.
//


import UIKit
import SnapKit

final class UniversityVC: UIViewController {
    
    let favoriteButton = UIButton()
    var isFavorite : Bool?
    let tableView = UITableView()
    var viewModel = UniversityViewModel()
    var isExpanded: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        FavoriteManager.shared.fetchData()
        loadAllUniversities()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderTopPadding = 0
        tableView.sectionFooterHeight = 10
        tableView.register(ProvinceCell.self, forHeaderFooterViewReuseIdentifier: ProvinceCell.identifier)
        tableView.register(UniversityCell.self, forCellReuseIdentifier: UniversityCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
  
    }
    
    func setupUI(){
        view.backgroundColor = .white
        let topView = UIView()
        topView.backgroundColor = .white
        view.addSubview(topView)
        topView.layer.borderWidth = 2
        
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.left.equalToSuperview().inset(2)
            make.height.equalTo(50)
        }
        
        topView.clipsToBounds = true
        topView.layer.cornerRadius = 2
        topView.layer.borderWidth = 4
        let label = UILabel()
        label.text = "Üniversiteler"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor =  .black
        topView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.top).offset(6)
            make.left.equalTo(topView.snp.left).inset(125)
            make.bottom.equalTo(topView.snp.bottom).inset(10)
        }
        
        topView.addSubview(favoriteButton)
        favoriteButton.tintColor = .systemRed
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.top)
            make.left.equalTo(label.snp.right).offset(40)
            make.bottom.equalTo(topView.snp.bottom)
            make.height.equalTo(50)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.right.left.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
   
    func loadAllUniversities() {
        viewModel.fetchUniversities(completion: {
            self.tableView.reloadData()
            
        }, failure: { ErrorMessage in
            print(ErrorMessage)
        })
    }
    @objc func favoriteButtonTapped(_ sender: UIButton) {
        let favoritesVC = FavoritesViewController()
        favoritesVC.modalPresentationStyle = .fullScreen
        self.present(favoritesVC, animated: true)
    }
    
    
}

extension UniversityVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.universitiesData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let datum = viewModel.universitiesData[section]
        guard let _ = datum.universities else { return 0 }
        return (datum.isExpanded ?? false) ? 1: 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UniversityCell.identifier) as! UniversityCell
        let datum = viewModel.universitiesData[indexPath.section]
        cell.configure(with: datum, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProvinceCell.identifier) as! ProvinceCell
        header.configure(with:viewModel.universitiesData[section], delegate: self)
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
           return 5
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /// Table view must expand as heigh as university count
        /// If any university isexpanded variable set true,
        /// Will add extra height per information cell
        
        guard let universities = viewModel.universitiesData[indexPath.section].universities else { return 0}
        let index = universities.firstIndex(where: {$0.isExpanded == true})
        
        return CGFloat(((universities.count * 60) + 10) + (index != nil ? 5 * 50 : 0) )
    }
}

extension UniversityVC: ProvinceCellDelegate {
    func plusMinusButtonTapped(for datum: Datum) {
      for i in viewModel.universitiesData.indices {
          viewModel.universitiesData[i].isExpanded = false
          if viewModel.universitiesData[i].province == datum.province {
              viewModel.universitiesData[i].isExpanded = datum.isExpanded
          }
        }
        tableView.reloadData()
    }
}

extension UniversityVC: UniversityCellDelegate {
    func reloadParentTableView(for datum: Datum?) {
        guard let datum,
        let index = viewModel.universitiesData.firstIndex(where: {$0.province == datum.province}) else { return }
        viewModel.universitiesData[index] = datum
        tableView.reloadData()
    }
}

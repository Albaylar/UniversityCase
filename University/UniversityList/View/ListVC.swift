//
//  ListVC.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 24.04.2024.
//

import UIKit

import UIKit

class ListVC: UIViewController {

    let tableView = UITableView()
    var expandedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func expandButtonTapped(sender: UIButton) {
        let section = sender.tag // Hangi section'ın expand/collapse edileceğini belirler
        if expandedIndexPath?.section == section {
            expandedIndexPath = nil // Eğer zaten expand edilmişse, collapse yap
        } else {
            expandedIndexPath = IndexPath(row: 0, section: section) // Expand et
        }
        tableView.reloadSections(IndexSet(integer: section), with: .automatic) // Değişikliği görselleştir
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // Toplam section sayısını döndür
        return 10 // Örnek olarak 10 section olduğunu varsayalım
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Section'ın altındaki satır sayısını döndür
        return expandedIndexPath?.section == section ? 2 : 1 // Eğer section expand edilmişse 2, değilse 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "Province \(indexPath.section)"
            
            // Expand/Collapse butonunu ekleyelim
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: expandedIndexPath?.section == indexPath.section ? "minus.circle.fill" : "plus.circle.fill"), for: .normal)
            button.addTarget(self, action: #selector(expandButtonTapped(sender:)), for: .touchUpInside)
            button.tag = indexPath.section // Hangi section'ı açıp kapatacağını bilelim
            cell.accessoryView = button
            
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "University \(indexPath.section)"
            return cell
        }
    }
}


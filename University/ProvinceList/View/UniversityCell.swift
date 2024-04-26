//
//  FooterTableViewCell.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 25.04.2024.
//



import UIKit

protocol UniversityCellDelegate: AnyObject {
    func reloadParentTableView(for datum: Datum?)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

final class UniversityCell: UITableViewCell, UniversityDetailCellDelegate {
    let tableView = UITableView()
    var datum: Datum?
    weak var delegate: UniversityCellDelegate?

    func setupUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.sectionFooterHeight = 10
        tableView.sectionHeaderTopPadding = 0
        tableView.contentInset = .zero
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(UniversityHeaderView.self, forHeaderFooterViewReuseIdentifier: UniversityHeaderView.identifier)
        tableView.register(UniversityDetailCell.self, forCellReuseIdentifier: UniversityDetailCell.identifier)

        contentView.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.bottom.right.left.equalToSuperview()
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with datum : Datum, delegate: UniversityCellDelegate) {
        self.datum = datum
        self.delegate = delegate
        tableView.reloadData()
    }

}
extension UniversityCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return datum?.universities?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (datum?.universities?[section].isExpanded ?? false) ? UniversityDataType.allCases.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UniversityDetailCell.identifier, for: indexPath) as! UniversityDetailCell
            cell.configure(with: datum?.universities?[indexPath.section], dataType: UniversityDataType.allCases[indexPath.row], delegate: self)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: UniversityHeaderView.identifier) as? UniversityHeaderView
        guard let university = datum?.universities?[section] else { return nil}
        let isFav = FavoriteManager.shared.favorites.contains({university.name ?? ""}())
        header?.configure(with: datum?.universities?[section], hasSingleUniversity: (datum?.universities?.count ?? 0) < 2, isfav: isFav, delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

extension UniversityCell: UniversityHeaderViewDelegate {
    
    func plusMinusButtonClicked(for university: University) {
        guard let universities = datum?.universities else { return }
        for i in universities.indices {
            datum?.universities?[i].isExpanded = false
            if universities[i].name == university.name {
                datum?.universities?[i].isExpanded = university.isExpanded
            }
        }
        delegate?.reloadParentTableView(for: datum)
    }
    
    func presentWebViewController(_ viewController: UIViewController) {
        delegate?.present(viewController, animated: true, completion: nil)
    }
}



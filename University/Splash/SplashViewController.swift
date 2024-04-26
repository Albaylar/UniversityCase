//
//  SplashViewController.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 26.04.2024.
//

import UIKit
import SwiftUI

class SplashViewController: UIViewController {
    let imageView = UIImageView()
    let universityLabel = UILabel()
    let viewModel = UniversityViewModel()
    let universityVC = UniversityVC()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startTimer()
        FavoriteManager.shared.fetchData()
        viewModel.fetchUniversities {
            self.universityVC.tableView.reloadData()
        } failure: { error in
            print(error)
        }
       
    }
    

    func setupUI(){
        view.backgroundColor = .white
        view.addSubview(imageView)
        imageView.image = UIImage(named: "university")
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(300)
        }
        view.addSubview(universityLabel)
        universityLabel.text = "Üniversiteler"
        universityLabel.textColor = .black
        universityLabel.font = .boldSystemFont(ofSize: 30)
        universityLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.right.left.equalToSuperview().inset(100)
            make.height.equalTo(100)
        }
        
    }
    func startTimer() {
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                self.presentUniversityVC()
            }
        }

        func presentUniversityVC() {
            let vc = UniversityVC()
            appContainer.router.newViewControl(for: vc)
        }


}




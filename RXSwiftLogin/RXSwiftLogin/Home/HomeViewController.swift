//
//  HomeViewController.swift
//  RXSwiftLogin
//
//  Created by Kim on 2017/8/30.
//  Copyright © 2017年 Brain. All rights reserved.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    
    var searchBarText: Observable<String> {
        return searchBar.rx
            .text
            .orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = HomeViewModel(searchText: searchBarText, service: CheckService.instance)
        
        viewModel.model
            .drive(tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (row, model, cell) in
                cell.textLabel?.text = model.name
                cell.detailTextLabel?.text = model.desc
                cell.imageView?.image = UIImage(named: model.imageString ?? "")
        }
            .addDisposableTo(disposeBag)
        
        
    }

}

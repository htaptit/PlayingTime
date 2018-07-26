//
//  PriceHistoryViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 6/29/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import Unbox
import SJSegmentedScrollView

extension PriceHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.histories?.history.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        cell.history = self.histories?.history[indexPath.row]
        
        return cell
    }
}

extension PriceHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        if let vc = main.instantiateViewController(withIdentifier: "TransactionDetailViewController") as? TransactionDetailViewController {
            vc.baseInforTransaction = self.histories?.history[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

class PriceHistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var socialUser: SocialUser? {
        didSet {
            self.getHistories()
        }
    }
    
    var histories: MyApiHistories?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = UIView()
        
        self.tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name("refreshData"), object: nil)
        
        self.getHistories()
    }
    
    @objc func refresh() {
        self.histories = nil
        self.getHistories()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("refreshData"), object: nil)
    }
    
    private func getHistories() {
        guard let _ = self.socialUser else {
            return
        }
        
        let api = MyApi.transactionHistory(email: self.socialUser!.email, type: self.socialUser!.type.rawValue)
        MyApiAdap.request(target: api, success: { (success) in
            do {
                let histories: MyApiHistories = try unbox(data: success.data)
                self.histories = histories
                
                self.tableView.reloadData()
            } catch {
                
            }
        }, error: { (error) in
            
        }) { (fail) in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension PriceHistoryViewController: SJSegmentedViewControllerViewSource {
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        return self.tableView
    }
}

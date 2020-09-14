//
//  ViewController.swift
//  NN4M Project
//
//  Created by Lorenzo on 11/09/2020.
//  Copyright © 2020 Lorenzo. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewNoConnection: UIView!
    
    var articles = [Article](){
        didSet{
            self.tableView.reloadData()
        }
    }
    
    let reachability = try! Reachability()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadJSON()        
        tableView.delegate = self
        tableView.dataSource = self
 
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.viewNoConnection.isHidden = false
            
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    
    func downloadJSON(){
        
        URLSession.shared.dataTask(with: URLHelper.getCatalog()) { (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                var result: Products?
                do {
                    result = try JSONDecoder().decode(Products.self, from: data)
                    for element in (result!.Products) {
                        self.articles.append(element)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }     
        }.resume()
    }
    
}

// MARK:- TableViewDelegate & TableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.tableLabel.text = articles[indexPath.row].name
        cell.priceLabel.text = "£\(articles[indexPath.row].cost)"
        
        if articles[indexPath.row].isTrending {
            cell.trendingLabel.isHidden = false
        } else {
            cell.trendingLabel.isHidden = true
        }
        
        cell.tableImage.downloaded(from: URLHelper.getMainImg(articleName: articles[indexPath.row].name, prodId: articles[indexPath.row].prodid))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController
        vc?.labelDetail = articles[indexPath.row].name
        vc?.labelCost = "£\(articles[indexPath.row].cost)"
        
        if let imageData = NSData(contentsOf: URL(string: articles[indexPath.row].allImages[0])!) {
            vc?.imageDetail = UIImage(data: imageData as Data)!
        }
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
}

// MARK: - UIImageview Extension

extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                
            }
        }.resume()
    }
}

//
//  ViewController.swift
//  NN4M Project
//
//  Created by Lorenzo on 11/09/2020.
//  Copyright © 2020 Lorenzo. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var articles = [Article](){
        didSet{
            self.tableView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        downloadJSON()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
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
        
        
        let defaultLink = "https://images.riverisland.com/is/image/RiverIsland/"
        let name = articles[indexPath.row].name
        let nameLink = name.replacingOccurrences(of: " ", with: "-")
        let completeLink = defaultLink + nameLink + "_" + articles[indexPath.row].prodid + "_main"

        cell.tableImage.downloaded(from: completeLink)
        
        
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
    

    
    func downloadJSON(){
        
        guard let url = URL(string: "https://static-ri.ristack-3.nn4maws.net/v1/plp/en_gb/2506/products.json")
            else {
                print("invalid URL")
                return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                
                var result: Products?
                
                do {
                    result = try? JSONDecoder().decode(Products.self, from: data)
                    
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
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

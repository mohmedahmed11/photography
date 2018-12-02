//
//  ViewController.swift
//  photography
//
//  Created by MAC on 01/12/2018.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeViewController: UITableViewController {
    var images:[Int:UIImage] = [:]
    var json = JSON()
    var count = 0
    var myImage:UIImage!
    var activityIndicatorView: UIActivityIndicatorView!
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageViewCell") as! ImageViewCell
        
        if images.count == 0 {
            return cell
        }
        
        if indexPath.row < images.count && indexPath.row >= 0 {
            let currentImage = images[indexPath.row]
            cell.mainImageView.image = currentImage
        }else{
            return cell
        }
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    override func loadView() {
        super.loadView()
        self.tableView.register(ImageViewCell.self, forCellReuseIdentifier: "imageViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // view loading progress
        if let presentedViewController = self.storyboard?.instantiateViewController(withIdentifier: "progress") {
            presentedViewController.providesPresentationContextTransitionStyle = true
            presentedViewController.definesPresentationContext = true
            self.present(presentedViewController, animated: false, completion: nil)
            
            // get all image data from server
            let url = "http://batch57.com/application/api.php?getImages"
            getAll(endUrl: url, onCompletion: { (data) in
                
                self.json = JSON(data!)
                self.count = self.json.count
                
                for i in 0..<self.json.count{
                    let imagePath = self.json[i]["path"]
                    let url = "http://batch57.com/\(imagePath)"
                    
                    // dwonnload images to fill images[UIImage]
                    dwonloadImage(endUrl: url, onCompletion: { (image) in
                        
                        self.myImage = image as! UIImage
                        
                        if self.myImage != nil {
                            self.images[i] = self.myImage
                        }
                        
                    }) { (err) in
                        print(err!)
                    }
                }
                
                // dismiss progress
                presentedViewController.dismiss(animated: true, completion: nil)
                
                self.tableView.reloadData()
                
            }) { (err) in
                print(err!)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // reload table data when view is appear after upload
        tableView.reloadData()
    }
}

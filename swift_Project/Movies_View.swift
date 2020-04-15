//
//  Movies_View.swift
//  swift_Project
//
//  Created by Mostafa Samir on 1/7/20.
//  Copyright © 2020 Mostafa Samir. All rights reserved.
//

import UIKit
import SDWebImage
import ReachabilitySwift
import BTNavigationDropdownMenu

//private let reuseIdentifier = "Cell"

class Movies_View: UICollectionViewController {

    let items = ["Most Popular", "Top Rated"]
    var menuView : BTNavigationDropdownMenu!
    
    var json : Dictionary<String,Any> = [:]
    var result:Array<Dictionary<String,Any>>=[]
    let path = "https://image.tmdb.org/t/p/w185/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.title("Menu"), items: items)
        
        self.navigationItem.titleView = menuView
       // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let reachability = try! Reachability()
        
        reachability!.whenReachable = { reachability in
            
            self.getData(jsonpath : "https://api.themoviedb.org/3/discover/movie?api_key=e71b0d253c69f0e5c1769fe51e6087d5&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1")
            //self.collectionView.reloadData()
        }
        reachability!.whenUnreachable = { _ in
            self.menuView.isUserInteractionEnabled = false
            var alert = UIAlertController.init(title: "No Internet", message: "Please Check Connection..!!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
        do {
            try reachability!.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        reachability?.stopNotifier()
        
       
    
        menuView!.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            //self.selectedCellLabel.text = items[indexPath]
            self!.json=[:]
            self!.result=[]
            if indexPath == 0
            {
                print("Did select item at index: \(indexPath)")
                 self!.getData(jsonpath : "https://api.themoviedb.org/3/discover/movie?api_key=e71b0d253c69f0e5c1769fe51e6087d5&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1")
                self?.collectionView.reloadData()
            }
            else{
                if indexPath == 1
                {
                    print("Did select item at index: \(indexPath)")
                    self!.getData(jsonpath : "https://api.themoviedb.org/3/movie/top_rated?api_key=e71b0d253c69f0e5c1769fe51e6087d5&language=en-US&page=1")
                    self?.collectionView.reloadData()
                }
                else{
                    print("cancel")
                }
            }
        }
        
    }
    
    
    func getData(jsonpath:String){
        
        print("print")
        //let url=URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=e71b0d253c69f0e5c1769fe51e6087d5&language=en-US&page=1")
        
        let url=URL(string: jsonpath)
        
        
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        UIApplication.shared.isNetworkActivityIndicatorVisible=true
        let task = session.dataTask(with: request) {
            (data,response,error) in
            do{
                print("json")
                self.json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as!  Dictionary<String,Any>
                let arr=self.json["results"] as! NSArray
                self.result = (self.json["results"] as? [[String:Any]])!
                /*for i in 0..<arr.count
                {
                    if let movie = (arr[i] as? Dictionary<String,Any>)
                    {
                        self.result.append(movie)
                    }
                }*/
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }catch{
                print("error \(error)")
            }
        }
        task.resume()
        
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return result.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         print("\n \n cellll 1 \n \n")
        
        let cell : ViewCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ViewCell
    
        if let imagepath=(result[indexPath.row]["poster_path"] as? String)
        {
            cell.img.sd_setImage(with: URL(string: path + imagepath))
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "sec") as! ViewController
        vc.name1 = (result[indexPath.row]["original_title"] as! String)
        vc.photo1 = (result[indexPath.row]["poster_path"] as! String)
        vc.year1 = (result[indexPath.row]["release_date"] as! String)
        vc.id = String((result[indexPath.row]["id"] as! Int))
        //vc.rate1 = (result[indexPath.row]["vote_average"] as! Double)
        
        let rate = Int(result[indexPath.row]["vote_average"]! as! NSNumber)
        let ratetext = (0 ..< rate).reduce("") { (acc, _) -> String in
            return acc + "⭐"
        }
        vc.rate1 = ratetext
        
        //    let rating = Int(dictM["vote_average"]! as! NSNumber)
        //    let rate1 = (0..<rating).reduce("") { (acc, _) -> String in
        //        return acc + "⭐"
        //    }
        
        vc.trailertext1 = (result[indexPath.row]["overview"] as! String)
   
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: UICollectionViewDelegate

//    func getData(){
//
//        print("print")
//        //let url=URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=e71b0d253c69f0e5c1769fe51e6087d5&language=en-US&page=1")
//
//        let url=URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=e71b0d253c69f0e5c1769fe51e6087d5&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1")
//
//        let request = URLRequest(url: url!)
//        let session = URLSession(configuration: URLSessionConfiguration.default)
//        UIApplication.shared.isNetworkActivityIndicatorVisible=true
//        let task = session.dataTask(with: request) {
//            (data,response,error) in
//            do{
//                print("json")
//                self.json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as!  Dictionary<String,Any>
//                let arr=self.json["results"] as! NSArray
//                for i in 0..<arr.count
//                {
//                    if let movie = (arr[i] as? Dictionary<String,Any>)
//                    {
//                        self.result.append(movie)
//                    }
//                }
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//
//            }catch{
//                print("error")
//            }
//        }
//        task.resume()
//
//    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

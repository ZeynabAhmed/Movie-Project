//
//  ViewController.swift
//  swift_Project
//
//  Created by Mostafa Samir on 1/6/20.
//  Copyright © 2020 Mostafa Samir. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tableview: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("count== \(trailers.count)")
        
        return trailers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableview.dequeueReusableCell(withIdentifier: "trailercell", for: indexPath)
        cell.textLabel!.text = trailers[indexPath.row].getName()
        cell.imageView?.image = UIImage(named: "YouTube-icon.png")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    var key = trailers[indexPath.row].getKey()
    
    if let url = URL(string: "https://www.youtube.com/watch?v=\(key)") {
        UIApplication.shared.open(url)
        print(url)
    }
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var rate: UILabel!
    
    
    @IBOutlet weak var trailertext: UITextView!
    @IBOutlet weak var movieurl: UILabel!
    
    var path1 = "https://api.themoviedb.org/3/movie/"
    var path2 = "/videos?api_key=89a950a1ef8df94c9deb0b5ea3f4254f&language=en-US"
    
    var name1=""
    var photo1=""
    var year1=""
    var rate1=""
    var id=""
    var trailers: [Trailer]=[]
    var trailertext1=""
    var movieurl1=""
    //var img = "1.png"
    var id1:Int=1
    var movies:Array<String> = []
    
    let path = "https://image.tmdb.org/t/p/w185/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        name.text=name1
        
        let fullImage = path + photo1
        photo.sd_setImage(with: URL(string: fullImage))
        
        year.text=year1
        rate.text=rate1
        trailertext.text=trailertext1
//        movieurl.text=movieurl1
        
        movies.append(name1)
        movies.append(year1)
        movies.append(trailertext1)
        movies.append(rate1)
        movies.append(fullImage)
        movies.append(String(id1))
        
        gettrailer(id: id)
    }

    func gettrailer (id:String){
        
        let url=URL(string : "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=e71b0d253c69f0e5c1769fe51e6087d5")
        
        
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        UIApplication.shared.isNetworkActivityIndicatorVisible=true
        let task = session.dataTask(with: request) {
            (data,response,error) in
            do{
                print("json")
                var json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as!  Dictionary<String,Any>
                let arr=json["results"] as! NSArray
                var result = json["results"] as! [[String:Any]]
                print("result== \(result.count)")
                for i in 0..<result.count
                {
                    var trailern = Trailer ()
                    trailern.setName(k: result[i]["name"] as! String)
                    trailern.setKey(k: result[i]["key"] as! String)

                    self.trailers.append(trailern)
                }
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
                
            }catch{
                print("error \(error)")
            }
        }
        task.resume()
        
    }
    
    
    
    @IBAction func addtofavourite(_ sender: Any) {
        let appdelegate=UIApplication.shared.delegate as! AppDelegate
        let managedcontext=appdelegate.persistentContainer.viewContext
        let entity=NSEntityDescription.entity(forEntityName: "Movie", in: managedcontext)
        let movie=NSManagedObject(entity: entity!, insertInto: managedcontext)
 print("core")
        movie.setValue(movies[0], forKey: "name1")
        movie.setValue(movies[1], forKey: "year1")
        movie.setValue(movies[2], forKey: "trailertext1")
        movie.setValue(movies[3], forKey: "rate1")
        movie.setValue(movies[4], forKey: "fullImage")
 print("set")
        id1+=1
        movie.setValue(movies[5], forKey: "id1")
        
        do{
            try managedcontext.save()
        }catch let error as NSError{
            print(error)
        }
  print("end button")
    }
    
}


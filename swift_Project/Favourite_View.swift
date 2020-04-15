//
//  Favourite_View.swift
//  swift_Project
//
//  Created by Mostafa Samir on 1/7/20.
//  Copyright © 2020 Mostafa Samir. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

//private let reuseIdentifier = "Cell"

class Favourite_View: UICollectionViewController {

    var obj = Movie()
    var manage : [NSManagedObject]=[]
   
    override func viewDidLoad() {
        super.viewDidLoad()

        print("did load")
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
        do{
        let appdelegate=UIApplication.shared.delegate as! AppDelegate
        let managedcontext=appdelegate.persistentContainer.viewContext
        let fetchrequest=NSFetchRequest<NSManagedObject>(entityName: "Movie")
        self.manage = try managedcontext.fetch(fetchrequest)
        }catch let errors as NSError{
            print(errors)
        }
        
        print("will appear")
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("section")
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
//        var num = Int(obj.id1!)
       print("num row")
//        return num!
        return manage.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
   
        let movie = manage[indexPath.row]
        var image_name = (movie.value(forKey: "fullImage") as? String)!
        
        let image = cell.viewWithTag(1) as! UIImageView
        image.sd_setImage(with: URL(string : image_name), placeholderImage: UIImage(named: "1.jpg"))
        
    
        
    print("after fetch")
        return cell
    }

    // MARK: UICollectionViewDelegate

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

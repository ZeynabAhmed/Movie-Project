//
//  Trailer.swift
//  swift_Project
//
//  Created by Mostafa Samir on 1/10/20.
//  Copyright © 2020 Mostafa Samir. All rights reserved.
//

import Foundation

class Trailer{
    
    private var key=""
    private var name=""
    
    init(){}
    
    init(key1:String , name1:String){
        key = key1
        name = name1
    }
    
    func setKey(k:String){
        key = k
    }
    func getKey()->String{
        return key
    }
    
    func setName(k:String){
        name = k
    }
    func getName()->String{
        return name
    }
    
}

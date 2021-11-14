//
//  SOCStorage.swift
//  MDB Social
//
//  Created by Rikio Dahlgren on 11/13/21.
//

import UIKit
// import Foundation
import FirebaseStorage

class SOCStorage {
    
    static let shared = SOCStorage()
    
    //let storage = Storage.storage(url: "gs://mdb-social-sp21.appspot.com")
    let storage = Storage.storage()
    
    let metadata: StorageMetadata = {
        let newMetadata = StorageMetadata()
        newMetadata.contentType = "image/jpeg"
        return newMetadata
    }()
        
        
}

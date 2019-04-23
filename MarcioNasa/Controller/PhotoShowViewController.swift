//
//  PhotoShowViewController.swift
//  MarcioNasa
//
//  Created by Marcio Ferminio on 21/04/19.
//  Copyright © 2019 Marcio Ferminio. All rights reserved.
//

import UIKit

class PhotoShowViewController: UIViewController {

    
    @IBOutlet weak var photo: UIImageView!
    
    
    @IBOutlet weak var fullName: UILabel!
    
    var urlPhoto: URL!
    var fullNameCamera = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        
        
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: self!.urlPhoto as URL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if(data != nil) {
                            
                            self!.photo.image = image
                            
                        }
                        
                    }
                }
            }
        }
        
        
    }
    
    
    func loadData(){
        
      fullName.text = fullNameCamera
        
    }

    
}


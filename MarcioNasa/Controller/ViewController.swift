//
//  ViewController.swift
//  MarcioNasa
//
//  Created by Marcio Ferminio on 21/04/19.
//  Copyright © 2019 Marcio Ferminio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.apiClient(satelite: 0)
        
    }

    
    func apiClient(satelite: Int){
        
        var urlConsome = "https://api.nasa.gov/mars-photos/api/v1/rovers/"
        
        switch satelite
        {
        case 0:
          
            urlConsome = urlConsome + "curiosity/photos?earth_date=2015-6-3&api_key=" + ApiKey.apiKey
            
        case 1:
            urlConsome = urlConsome +  "opportunity/photos?earth_date=2015-6-3&api_key=" + ApiKey.apiKey
            
        case 2:
            urlConsome =  urlConsome + "spirit/photos?earth_date=2015-6-3&api_key="  + ApiKey.apiKey
            
        default:
            break
        }
        
        
        guard let url = URL(string:urlConsome ) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            
            
            do {
                
                let data = try? JSONDecoder().decode(Photo.self, from: dataResponse)

                let counter = data!.photos.count

                
                DataSource.dataSourceCode.removeAll()
                
                
                for i in 0..<counter {

                    var row = [String]()
                    
                    row.append(data!.photos[i].camera.name)
                    row.append(data!.photos[i].camera.fullName)

                    
                    let aString = data!.photos[i].imgSrc
                    let newString = aString.replacingOccurrences(of: "http", with: "https", options: .literal, range: nil)
                    
                    row.append(newString)
                    
                    DataSource.dataSourceCode.append(row)
                    
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadSections(IndexSet(integer: 0))
                    
                }
                
            }
        }
        task.resume()
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataSource.dataSourceCode.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.Label.text = DataSource.dataSourceCode[indexPath.row][0]
      
        let url = NSURL(string: DataSource.dataSourceCode[indexPath.row][2])
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url! as URL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.image.contentMode = .scaleAspectFit
                        cell.image.image = image
                    }
                }
            }
        }
        
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let photoShowViewController = mainStoryBoard.instantiateViewController(withIdentifier: "PhotoShowViewController") as! PhotoShowViewController
        
        photoShowViewController.fullNameCamera = DataSource.dataSourceCode[indexPath.row][1]
        photoShowViewController.urlPhoto = NSURL(string: DataSource.dataSourceCode[indexPath.row][2]) as URL?
        
        self.navigationController?.pushViewController(photoShowViewController, animated: true)
        
    }
    
    
    @IBAction func IndexChange(_ sender: Any) {        
        
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            apiClient(satelite: 0)
        case 1:
            apiClient(satelite: 1)
        case 2:
            apiClient(satelite: 2)
        default:
            break
        }
    }
    
    
}

//
//  CarsList.swift
//  Uber
//
//  Created by apple on 01/04/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class CarsList: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource {

    var names = ["Mini","Pool","Sedan","Auto","Shuttle","Bus"]
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource =  self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarCell", for: indexPath) as! CarCell
        cell.carImage.image = UIImage(named:names[indexPath.row])
        cell.carName.text = names[indexPath.row]
        return cell
    }
    
}

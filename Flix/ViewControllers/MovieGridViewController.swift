//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Stephen Karukas on 10/25/19.
//  Copyright © 2019 Stephen Karukas. All rights reserved.
//

import UIKit

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var movies = [[String:Any]]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let numPerRow = 2
        let spacing = 4
        layout.minimumLineSpacing = CGFloat(spacing)
        layout.minimumInteritemSpacing = CGFloat(spacing)
        
        let width = (view.frame.size.width - CGFloat(numPerRow-1) * layout.minimumLineSpacing) / CGFloat(numPerRow)
        layout.itemSize = CGSize(width: width, height: width * 3/2)
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

            self.movies = dataDictionary["results"] as! [[String: Any]]
            //print(self.movies);
            self.collectionView.reloadData()
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
            task.resume()
    }
        // Do any additional setup after loading the view.
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        
        // add movie poster
        let url = "https://image.tmdb.org/t/p/w185"
        let posterUrl = URL(string: (url + (movie["poster_path"] as! String)))
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! MovieDetailsViewController;
        
        // Find selected movie
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        let movie = movies[indexPath.item]
        
        // Pass selected movie to details
        controller.movie = movie;
        collectionView.deselectItem(at: indexPath, animated: true)
    }

}

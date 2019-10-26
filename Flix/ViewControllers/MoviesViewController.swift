//
//  MoviesViewController.swift
//  Flix
//
//  Created by Stephen Karukas on 10/15/19.
//  Copyright © 2019 Stephen Karukas. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var movies = [[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

            self.movies = dataDictionary["results"] as! [[String: Any]]
            
            self.tableView.reloadData()
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        let movie = movies[indexPath.row]
        
        // add movie title
        let title = movie["title"] as! String
        cell.titleLabel.text = title
        
        // add movie synopsis
        let synopsis = movie["overview"] as! String
        cell.synopsisLabel.text = synopsis
        
        // add movie poster
        let url = "https://image.tmdb.org/t/p/w185"
        let posterUrl = URL(string: (url + (movie["poster_path"] as! String)))
        cell.movieImage.af_setImage(withURL: posterUrl!)
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! MovieDetailsViewController;
        
        // Find selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // Pass selected movie to details
        controller.movie = movie;
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

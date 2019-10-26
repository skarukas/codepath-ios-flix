//
//  MovieDetailsViewController.swift
//  Flix
//
//  Created by Stephen Karukas on 10/25/19.
//  Copyright © 2019 Stephen Karukas. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var movie: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit()
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        // add movie poster
        let url = "https://image.tmdb.org/t/p/w185"
        let posterUrl = URL(string: (url + (movie["poster_path"] as! String)))
        posterView.af_setImage(withURL: posterUrl!)
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + (movie["backdrop_path"] as! String))
        backdropImage.af_setImage(withURL: backdropUrl!)
        
        posterView.layer.masksToBounds = true
        posterView.layer.borderWidth = 1.5
        posterView.layer.borderColor = UIColor.white.cgColor
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

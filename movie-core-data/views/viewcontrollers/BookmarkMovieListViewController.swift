//
//  BookmarkMovieListViewController.swift
//  movie-core-data
//
//  Created by tunlukhant on 9/25/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import CoreData

class BookmarkMovieListViewController: UIViewController {

    @IBOutlet weak var collectionviewBookmark: UICollectionView!
    
    var MovieList: [MovieBookmarkVO]?
    
    var fetchResultController: NSFetchedResultsController<MovieBookmarkVO>!
    
    let TAG : String = "BookmarkMovieListViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        URLCache.shared.removeAllCachedResponses()
    }
    
    fileprivate func initBookMarkListFetchRequest() {
        let fetchRequest: NSFetchRequest = MovieBookmarkVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
            if let objects = fetchResultController.fetchedObjects, objects.count == 0 {
                self.MovieList = objects
            }
        } catch {
            print("failed to fetch bookmarked list: \(error.localizedDescription)")
        }
        
    }
    
//    @objc func letsRefresh(_ refreshControl: UIRefreshControl) {
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Saved Movies"
    }
    
    private func initView() {
        
        collectionviewBookmark.dataSource = self
        
        collectionviewBookmark.delegate = self
        
        collectionviewBookmark.backgroundColor = Theme.background
        
        initBookMarkListFetchRequest()
        
//        self.collectionviewBookmark.addSubview(refreshControl)
        
    }

}

extension BookmarkMovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieDetailsViewController = segue.destination as? MovieDetailsViewController {
            
            if let indexPaths = collectionviewBookmark.indexPathsForSelectedItems, indexPaths.count > 0 {
                let selectedIndexPath = indexPaths[0]
                let movie = Int(fetchResultController.object(at: selectedIndexPath).id)
                movieDetailsViewController.movieId = movie
                
                let orgMovie = MovieVO.getMovieById(movieId: movie)
                
                self.navigationItem.title = orgMovie?.original_title ?? ""
            }
            
        }
    }
}

extension BookmarkMovieListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchResultController.sections?.count ?? 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultController.sections?[section].numberOfObjects ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bookmarkedMovie = fetchResultController.object(at: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieBookmarkListCollectionViewCell.identifier, for: indexPath) as? MovieBookmarkListCollectionViewCell else {
            return UICollectionViewCell()
        }
        let orgmovie = MovieVO.getMovieById(movieId: Int(bookmarkedMovie.id))
        cell.data = orgmovie
        return cell
    }


}

extension BookmarkMovieListViewController : NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        collectionviewBookmark.reloadData()
    }
}

extension BookmarkMovieListViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10;
        return CGSize(width: width, height: width * 1.45)
    }
}


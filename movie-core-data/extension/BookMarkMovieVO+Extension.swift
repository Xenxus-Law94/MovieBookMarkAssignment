//
//  BookMarkMovieVO+Extension.swift
//  movie-core-data
//
//  Created by tunlukhant on 9/26/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import CoreData

extension MovieBookmarkVO {
    
    static func getBookMarkById(bookedId: Int) -> MovieBookmarkVO? {
        let fetchRequest: NSFetchRequest<MovieBookmarkVO> = MovieBookmarkVO.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", bookedId)
        fetchRequest.predicate = predicate
        
        do{
            let data = try
                CoreDataStack.shared.viewContext.fetch(fetchRequest)
            if data.isEmpty {
                return nil
            }
            return data[0]
        } catch let dataErr {
            print(dataErr.localizedDescription)
            return nil
        }
        
    }
    
    static func getBookmarkedMovieList() -> [MovieBookmarkVO]? {
        let fetchRequest : NSFetchRequest<MovieBookmarkVO> = MovieBookmarkVO.fetchRequest()
        
        do {
            let data = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            if data.isEmpty {
                return nil
            }
            return data
        } catch {
            print("failed to fetch bookmarked list: \(error.localizedDescription)")
            return nil
        }
        
    }
    
    static func getBookMaredBool(bookedId: Int) -> Bool {
        let fetchRequest: NSFetchRequest<MovieBookmarkVO> = MovieBookmarkVO.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", bookedId)
        fetchRequest.predicate = predicate
        do {
            let data = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            if data.isEmpty {
                return false
            }
            
            return true
        } catch {
            print("failed to fetch bookmarked list: \(error.localizedDescription)")
            return false
        }
    }
    
    
}

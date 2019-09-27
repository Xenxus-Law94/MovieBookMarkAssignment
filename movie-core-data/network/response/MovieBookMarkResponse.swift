//
//  MovieBookMarkResponse.swift
//  movie-core-data
//
//  Created by tunlukhant on 9/26/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import CoreData

struct MovieBookMarkResponse: Codable {
    let id: Int?
    
    static func saveMovieBookMarkEntity(data : Int, context : NSManagedObjectContext) {
        let entity = MovieBookmarkVO(context: context)
        if data > 0 {
            entity.id = Int32(data)
        } else {
            return
        }
        do {
            try context.save()
        } catch {
            print("failed to save BookMarked Movie : \(error.localizedDescription)")
        }
        
    }
    
    static func deleteMovieBookMarkEntity(data: Int, context: NSManagedObjectContext) {
        var id: Int
        if data > 0{
            id = data
        } else {
            return
        }
        
        if let result = MovieBookmarkVO.getBookMarkById(bookedId: id) {
            do {
                    try context.delete(result)
                do {
                    try context.save()
                } catch {
                    print("failed to delete book marked movie : \(error.localizedDescription)")
                }
            } catch {
                print("failed to delete book marked movie : \(error.localizedDescription)")
            }
        }
    }
}

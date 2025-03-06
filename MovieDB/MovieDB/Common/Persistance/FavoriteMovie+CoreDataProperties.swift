//
//  FavoriteMovie+CoreDataProperties.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//
//

import Foundation
import CoreData


extension FavoriteMovie {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovie> {
        return NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
    }

    @NSManaged public var id: Int64
    @NSManaged public var posterPath: String?
    @NSManaged public var title: String?

}

extension FavoriteMovie : Identifiable {

}

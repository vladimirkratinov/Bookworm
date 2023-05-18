//
//  DataController.swift
//  Bookworm
//
//  Created by Vladimir Kratinov on 2023-05-17.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Bookworm")
    static let shared = DataController()
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    /// Fetching Book Entity from CoreData
    func fetchBooks() -> [Book]? {
            let request: NSFetchRequest<Book> = Book.fetchRequest()
            
            do {
                let books = try container.viewContext.fetch(request)
                return books
            } catch {
                print("Error fetching books: \(error.localizedDescription)")
                return nil
            }
        }
}

//
//  DataController.swift
//  Bookworm
//
//  Created by Vladimir Kratinov on 2023-05-17.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Bookworm")
    @Published var dataDeleted = false {
        didSet {
            UserDefaults.standard.set(dataDeleted, forKey: "dataDeletedKey")
        }
    }
    var result: JSONList?
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        dataDeleted = UserDefaults.standard.bool(forKey: "dataDeletedKey")
    }
    
    //MARK: - Fetching Book Entity from CoreData
    func fetchBooks() {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        
        do {
            let books = try container.viewContext.fetch(request)
            
            if !books.isEmpty {
                books.forEach {
                    print("Title: \($0.title!)")
                }
            } else {
                print("Fetched Book List is Empty!")
            }
        } catch {
            print("Error fetching books: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Fetch JSON data from file
    func fetchJSON() {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)

        // Decode JSON data into model objects
        do {
            let decoder = JSONDecoder()
            let jsonData = try Data(contentsOf: url)
            result = try decoder.decode(JSONList.self, from: jsonData)
            
            //Decode JSON data into model objects
            if let result = result {
                for bookData in result.data {
                    // Check if the book already exists in CoreData
                    let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "title == %@ AND author == %@", bookData.title, bookData.author)
                    
                    do {
                        let existingBooks = try container.viewContext.fetch(fetchRequest)
                        if let existingBook = existingBooks.first {
                            // Book already exists, do not save changes
                            print("\(existingBook.title ?? "") already exists in CoreData. Skipping...")
                            continue
                        }
                    }
                    catch {
                        print("Failed to fetch existing books: \(error)")
                    }
                    
                    // Create a new book object and set its properties
                    let newBook = Book(context: container.viewContext)
                    newBook.id = UUID()
                    newBook.title = bookData.title
                    newBook.genre = bookData.genre
                    newBook.author = bookData.author
                    newBook.rating = bookData.rating
                    newBook.review = bookData.review
                    
                    dataDeleted = false
                }
            }
            else {
                print("Failed to parse JSON data")
            }
        }
        catch {
            print("Failed to decode JSON data: \(error)")
        }
        
        // Save changes to CoreData
        do {
            try container.viewContext.save()
            print("Books saved to CoreData successfully")
        }
        catch {
            print("Failed to save books to CoreData: \(error)")
        }
    }
    
    //MARK: - Delete Request
    
    func deleteAllRequest() {
        // Create a fetch request to fetch all objects of the "Book" entity
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Book")
        
        // Create a batch delete request with the fetch request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            // Execute the batch delete request
            try container.viewContext.execute(batchDeleteRequest)
            try container.viewContext.save()
            dataDeleted = true // Set the flag to true to trigger UI update
            print("All data deleted from CoreData successfully")
        }
        catch {
            print("Failed to delete data from CoreData: \(error)")
        }
    }
}

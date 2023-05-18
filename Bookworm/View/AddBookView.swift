//
//  AddBookView.swift
//  BookwormReal
//
//  Created by Vladimir Kratinov on 2023-05-17.
//

import SwiftUI

struct AddBookView: View {
    @Environment (\.managedObjectContext) var moc
    @Environment (\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 0
    @State private var selectedOption = 0
    @State private var review = ""
    
    private let options = [
        "Fiction",
        "Fantasy",
        "Horror",
        "Kids",
        "Mystery",
        "Poetry",
        "Romance",
        "Thriller"
    ]
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $selectedOption) {
                        ForEach(0..<options.count, id: \.self) { index in
                            Text(options[index]).tag(index)
                        }
                    }
                }
                
                Section {
                    TextEditor(text: $review)
                        
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }
                
                Section {
                    Button("Save") {
                        //add the book
                        let newBook = Book(context: moc)
                        newBook.id = UUID()
                        newBook.title = title
                        newBook.author = author
                        newBook.rating = Int16(rating)
                        newBook.genre = options[selectedOption]
                        newBook.review = review

                        try? moc.save()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add Book")
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}

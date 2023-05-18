//
//  ContentView.swift
//  Bookworm
//
//  Created by Vladimir Kratinov on 2023-05-17.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink {
                        DetailView(book: book)
                    } label: {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknown Titile")
                                    .font(.headline)
                                
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreen.toggle()
                    } label: {
                        Label("Add Book", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

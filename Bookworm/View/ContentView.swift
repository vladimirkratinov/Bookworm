//
//  ContentView.swift
//  Bookworm
//
//  Created by Vladimir Kratinov on 2023-05-17.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title),
        SortDescriptor(\.author)
    ]) var books: FetchedResults<Book>
    
    @EnvironmentObject var dataController: DataController
    @State private var showingAddScreen = false
    @State private var showNavigationStack = true
    
    var body: some View {
        NavigationStack {
            if showNavigationStack {
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
                    .onDelete(perform: deleteBooks) // perform deletion on ForEach (!)
                }
                .navigationTitle("Bookworm")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                        }
                        
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
            else {
                Spacer()
                Text("Data has been deleted")
                Spacer()
            }
            
            Button {
                dataController.fetchBooks()
                dataController.fetchJSON()
            } label: {
                Text("Fetch CoreData")
            }
            
            Button {
                dataController.deleteAllRequest()
            } label: {
                Text("Delete All")
            }
        }
        .onReceive(dataController.$dataDeleted) { _ in
            // Perform UI updates here
            // This closure will be triggered when the dataDeleted flag changes
            // Refresh the view or perform any necessary UI updates
            showNavigationStack = !dataController.dataDeleted
        }
    }
    
    //MARK: - Methods
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

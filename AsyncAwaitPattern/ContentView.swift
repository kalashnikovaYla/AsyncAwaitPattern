//
//  ContentView.swift
//  AsyncAwaitPattern
//
//  Created by sss on 24.06.2023.
//

import SwiftUI

struct Course: Decodable, Identifiable {
    
    let id, numberOfLessons : Int
    let name, link, imageUrl: String
}


class ContentViewModel: ObservableObject {
    
    @Published var isFetching = false
    @Published var courses = [Course]()
    @Published var errorMessange = ""
    
    let url = "https://api.letsbuildthatapp.com/jsondecodable/courses"
    
    init() {
        
    }
    
    @MainActor
    func fetchData() async {
        guard let url = URL(string: url) else {return }
        let urlRequest = URLRequest(url: url)
        
        do {
            isFetching = true
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let response = response as? HTTPURLResponse, response.statusCode > 300 {
                self.errorMessange = "Failed to hint endpoint with bad status code"
            }
            self.courses = try JSONDecoder().decode([Course].self, from: data)
            isFetching = false
            
        } catch {
            isFetching = false
            print("Failed to reach endpoint: \(error)")
        }
    }
}


struct ContentView: View {
    
    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.isFetching {
                    ProgressView()
                }
                
                ForEach(viewModel.courses) { course in
                    let url = URL(string: course.imageUrl)
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }

                    Text(course.name)
                }
            }
            .navigationTitle("Courses")
            .navigationBarItems(leading: refresh)
            .task {
                await viewModel.fetchData()
            }
        }
    }
    private var refresh: some View {
        Button {
            Task.init {
                viewModel.courses.removeAll()
                await viewModel.fetchData()
            }
        } label: {
            Text("Refresh")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

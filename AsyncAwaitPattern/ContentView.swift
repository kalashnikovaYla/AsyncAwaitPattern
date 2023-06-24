//
//  ContentView.swift
//  AsyncAwaitPattern
//
//  Created by sss on 24.06.2023.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    let url = "https://api.letsbuildthatapp.com/jsondecodable/courses"
}


struct ContentView: View {
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Here is my content")
            }
            .navigationTitle("Courses")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

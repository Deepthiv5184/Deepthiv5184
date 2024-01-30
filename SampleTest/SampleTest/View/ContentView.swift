//
//  ContentView.swift
//  SampleTest
//
//  Created by DEEPTHI on 29/01/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = SchoolViewModel(serviceManager: WebService())
    
    var body: some View {
        List(viewModel.schoolNames) { schoolData in
            NavigationLink(destination: DetailView(description: schoolData.paragraph)){
                ListCellView(title: schoolData.schoolName, subTitle: schoolData.dbn)
            }
        }
        .onAppear {
            if viewModel.schoolNames.isEmpty {
                Task {
                    await viewModel.fetchDataFromApi()
                }
            }
        }
    }
    
}

struct ListCellView: View {
    var title: String
    var subTitle: String
    var body: some View {
        VStack {
            Text(title)
                .bold()
                .lineLimit(1)
            Text(subTitle)
                .lineLimit(1)
        }.frame(alignment: .leading)
    }
}

struct DetailView: View {
    @State var description: String
    var body: some View {
        VStack {
            Text(description)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

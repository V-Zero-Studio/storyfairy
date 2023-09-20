//
//  ContentView.swift
//  storyfairy
//
//  Created by Chunxu Yang on 8/18/23.
//

import SwiftUI


struct HeaderToolbar: ToolbarContent {
    let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    var title: String
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            NavigationLink{
                InitView().modifier(Header())
            } label: {
                Text("StoryFairy").font(.customSmall)
                    .bold()
                    .foregroundColor(Color("UCLASecondaryColor"))
//                    .background(Color.red)
                
                Text(buildNumber ?? "")
                    .padding(.vertical, 3)
                    .padding(.horizontal, 5)
                    .border(Color("UCLASecondaryColor"), width: 1.5)
                    .foregroundColor(Color("UCLASecondaryColor"))
            }
                
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Text(title)
                .font(.customSmall)
                .foregroundColor(Color("UCLASecondaryColor"))
        }
    }
}

struct Header: ViewModifier {
    
    
    func body(content: Content) -> some View {
        content
            .toolbarBackground(.visible, for: .navigationBar, .tabBar)
            .toolbarBackground(Color("UCLAPrimaryColor"), for: .navigationBar, .tabBar)
            
            .navigationBarBackButtonHidden()
    }
}

struct MainView: View {
    @StateObject var storyViewModel: StoryViewModel = StoryViewModel()
    
    var body: some View {
        NavigationStack {
            InitView()
        }
        .environmentObject(storyViewModel)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

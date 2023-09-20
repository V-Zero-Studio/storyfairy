//
//  EndView.swift
//  storyfairy
//
//  Created by Chunxu Yang on 8/18/23.
//

import SwiftUI

struct EndView: View {
    @EnvironmentObject var storyViewModel: StoryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "moon.stars.fill").font(.customTitle).symbolRenderingMode(.palette)
                    .foregroundStyle(Color("UCLASecondaryColor"), Color("UCLAPrimaryColor"))
                Text("The End!").font(.customTitle)
            }
            
            Spacer()
            HStack {
                ButtonView(icon: "chevron.left", disabled: false, onClick: {self.presentationMode.wrappedValue.dismiss()}
                )
                Spacer()
                
                Button(action: {
                    storyViewModel.setBasicInfo(characters: [], scene: "")
                }, label: {
                    NavigationLink(destination: InitView(), label: {Text("Create another story").font(.customBody)
                            .padding()
                            .bold()
                            .frame(height: 70)
                            .background(Color("UCLAPrimaryColor"))
                            .foregroundColor(Color.white)
                            .clipShape(Capsule())
                            .shadow(radius: 10)
                    })
                })
                    
            }
            .padding(30)
        }.toolbar{HeaderToolbar(title: "")}.modifier(Header())
    }
}

struct EndView_Container: View {
    @StateObject var storyViewModel = StoryViewModel()
    
    var body: some View {
        NavigationStack {
            EndView()
        }.environmentObject(storyViewModel)
    }
}

struct EndView_Previews: PreviewProvider {
    static var previews: some View {
        EndView_Container()
        
    }
}

//
//  HeaderView.swift
//  storyfairy
//
//  Created by Chunxu Yang on 8/18/23.
//

import SwiftUI

struct HeaderView: View {
    let storyTitle: String
    var body: some View {
        HStack {
            Text("StoryFairy")
                .font(.title)
                .foregroundColor(Color("UCLASecondaryColor"))
            Spacer()
            Text(storyTitle).font(.subheadline)
                .foregroundColor(Color("UCLASecondaryColor"))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 50)
        .background(Color("UCLAPrimaryColor").edgesIgnoringSafeArea(.all))
        
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(storyTitle: "123123")
    }
}

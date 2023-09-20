//
//  StoryView.swift
//  storyfairy
//
//  Created by Chunxu Yang on 8/21/23.
//

import SwiftUI

struct SlideImageView: View {
    var image: String
    
    var body: some View {
        AsyncImage(
            url: URL(string: image)
        ) { image in
            image
                .resizable()
                .scaledToFill()
                .aspectRatio(1.0, contentMode: .fill)
        } placeholder: {
            Color.gray.scaledToFill()
        }.cornerRadius(10).shadow(radius: 10).padding()
    }
    
}

struct SlideTextView: View {
    var text: String
    var height: CGFloat
    var keywords: [String]
    var hasTitle: Bool
    @Binding var selectedKeyword: String?
    
    var body: some View {
        VStack {
            
            ScrollView {
                Text(text).font(.customBody).padding()
            }
//            .background(Color(uiColor: UIColor.systemBackground))
//            .cornerRadius(10)
//            .padding()
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(.gray, lineWidth: 1)
//                    .padding()
//
//            )
            
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
//            .shadow(radius: 5)
            
            
            if !keywords.isEmpty {
                SimpleTagSelectionView(title: hasTitle ? "Add new elements to the story:": nil, choices: keywords, selected: $selectedKeyword).frame(maxWidth: .infinity, alignment: .leading).padding()
            }
        }
    }
}

struct SlideView: View {
    var slide: Slide
    var showKeywords: Bool
    var isFirstSlide: Bool
    @Binding var selectedKeyword: String?
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                // Header
                if geometry.size.width > geometry.size.height {
                    
                    
                    GeometryReader { geometry2 in
                        HStack (spacing: 10) {
                            SlideImageView(image: slide.image)
                            SlideTextView(text: slide.text, height: geometry2.size.height * 0.5, keywords: showKeywords ? slide.keywords:[], hasTitle: isFirstSlide, selectedKeyword: $selectedKeyword)
                            
                            
                        }
                    }
                    
                } else {
                    GeometryReader { geometry2 in
                        ScrollView {
                            SlideImageView(image: slide.image)
                            SlideTextView(text: slide.text, height: geometry2.size.height * 0, keywords: showKeywords ? slide.keywords:[], hasTitle: isFirstSlide, selectedKeyword: $selectedKeyword)
                        }
                    }
                }
                
            }
        }
        .padding()
        
    }
}

/// For previews
///


struct SlideView_Container: View {
    @State var selectedKeyword: String? = nil
    var body: some View {
        NavigationStack {
            SlideView(slide: Slide(text: "A dog is chasing a cat, A dog is chasing a cat, A dog is chasing a cat, A dog is chasing a cat, A dog is chasing a cat, A dog is chasing a cat, A dog is chasing a cat, A dog is chasing a cat, A dog is chasing a cat, A dog is chasing a cat, A dog is chasing a cat, A dog is chasing a cat, A dog is chasing a cat, A dog is chasing a cat, A dog is chasing a cat, A dog is chasing a cat, A dog is chasing a cat, A dog is chasing a cat, ", image: "https://picsum.photos/1000", keywords: ["Butterfly", "A moon", "A breeze", "C", "DDDDDDDDDDD"]), showKeywords: true, isFirstSlide: true, selectedKeyword: $selectedKeyword)
        }
    }
}



struct SlideView_Previews: PreviewProvider {
    static var previews: some View {
        SlideView_Container()
    }
}

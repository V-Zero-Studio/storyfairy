//
//  StoryView.swift
//  storyfairy
//
//  Created by Chunxu Yang on 8/23/23.
//

import SwiftUI

struct StoryView: View {
    @EnvironmentObject var storyViewModel: StoryViewModel
    @State var selectedKeyword: String? = nil
    @State var currentSlide: Int = 1
    @State var nextLoading: Bool = false
    
    @StateObject private var slideFetcher = SlideFetcher()
    @StateObject private var keywordsFetcher = KeywordsFetcher()
    
    @State var nextSlide: Slide? = nil
    
    
    let allSlides: Int = 10
    
    //    let transition: AnyTransition = .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
    
    
    
    func refreshNext() async {
        self.nextLoading = true
        self.nextSlide = nil
        var newKeyword: [String] = []
        
        if self.selectedKeyword != nil {
            newKeyword.append(self.selectedKeyword!)
        }
        
        await slideFetcher.fetch(with: StoryBody(story: storyViewModel.story, new_keywords: newKeyword))
        
        self.nextSlide = slideFetcher.data
        self.nextLoading = false
    }
    
    
    var body: some View {
        VStack {
            if currentSlide > 0 && currentSlide <= storyViewModel.story.slides.count {
                SlideView(slide: storyViewModel.story.slides[currentSlide - 1], showKeywords: currentSlide <= allSlides - 3, isFirstSlide: currentSlide == 1, selectedKeyword: $selectedKeyword
                )
            } else {
                Text("Slide not available")
            }
            
            Spacer()
            HStack {
                ButtonView(icon: "chevron.left", disabled: currentSlide == 1, onClick: {
                    currentSlide = currentSlide - 1
                })
                Spacer()
                Text("\(currentSlide) / \(allSlides)").font(.title2)
                Spacer()
                
                if currentSlide == allSlides {
                    ButtonView(icon: "chevron.right", onClick: {}, navigateTo: AnyView(EndView()))
                }
                else {
                    ButtonView(icon: "chevron.right",disabled: false,
                               onClick: {
                        
                        self.selectedKeyword = nil
                        
                        if (currentSlide >= storyViewModel.story.slides.count) {
                            if ((self.nextSlide) != nil) {
                                print(String(describing: self.nextSlide))
                                storyViewModel.addSlide(slide: self.nextSlide!)
                                self.nextSlide = nil
                            }
                            currentSlide += 1
                            
                            if ((self.nextSlide) == nil) {
                                await refreshNext()
                            }


                        } else {
                            currentSlide += 1
                        }
                        
                        
                        
                        
                        //                        if (currentSlide < storyViewModel.story.slides.count) {
                        //                            currentSlide += 1
                        //                        } else {
                        //                            self.nextLoading = true
                        //
                        //                            let new_slide = await refreshNext()
                        //
                        //
                        //
                        //
                        //
                        //                            currentSlide += 1
                        //                            self.nextLoading = false
                        //                        }
                        
                    }, loading: nextLoading).onChange(of: selectedKeyword) { newValue in
                        
                            Task {
                                await refreshNext()
                            }
                        
                    }
                }
            }
            .padding(30)
            .onAppear {
                if self.currentSlide >= storyViewModel.story.slides.count && storyViewModel.story.slides.count < allSlides {
                    print("First Refreshing")
                    Task {
                        await self.refreshNext()
                    }
                }
            }
            
        }
        .navigationBarBackButtonHidden()
//        .toolbar { HeaderToolbar(title: storyViewModel.story.title) }
//            .modifier(Header())
    }
}

struct StoryView_Container: View {
    @StateObject var storyViewModel: StoryViewModel = StoryViewModel()
    
    
    var body: some View {
        NavigationStack {
            StoryView().onAppear {
                
                storyViewModel.story.slides.append(Slide(text: "A dog is chasing a cat", image: "https://picsum.photos/1000", keywords: ["A bird", "Some flowers"]))
            }
        }.environmentObject(storyViewModel)
    }
}

struct StoryView_Previews: PreviewProvider {
    
    @StateObject var storyViewModel: StoryViewModel = StoryViewModel()
    
    static var previews: some View {
        StoryView_Container()
    }
}

//
//  ButtonView.swift
//  storyfairy
//
//  Created by Chunxu Yang on 8/18/23.
//

import SwiftUI

struct ButtonView: View {
    let icon: String
    let disabled: Bool?
    let onClick: () async -> Void
    let navigateTo: AnyView?
    let loading: Bool?
    
    init(icon: String, disabled: Bool? = false, onClick: @escaping  () async -> Void, navigateTo: AnyView? = nil, loading: Bool? = false) {
        self.icon = icon
        self.disabled = disabled
        self.onClick = onClick
        self.navigateTo = navigateTo
        self.loading = loading
    }
    
    @State private var isActive = false
    
    var body: some View {
        if let destination = navigateTo {
            VStack {
                Button(action:{
                    Task {
                        if !(disabled ?? false) && !(loading ?? false) {
                            Task {
                                await onClick()
                                isActive = true
                            }
                        }
                    }
                }) {
                    ButtonContent(loading: loading ?? false, icon: icon, disabled: disabled ?? false)
                }.navigationDestination(isPresented: $isActive) { destination }
                
            }
            
        } else {
            Button(action: {
                Task {
                    if !(disabled ?? false) && !(loading ?? false) {
                        Task {
                            await onClick()
                            isActive = true
                        }
                    }
                }
            }) {
                ButtonContent(loading: loading ?? false, icon: icon, disabled: disabled ?? false)
            }
        }
    }
}

struct ButtonContent: View {
    var loading: Bool
    var icon: String
    var disabled: Bool
    
    @State private var rotationAngle: Angle = .degrees(0)  // Initialize rotation angle
    
    var body: some View {
        Image(systemName: loading ? "" : icon)
            .font(.largeTitle)
            .bold()
            .frame(width: 70, height: 70)
            .background(Color("UCLAPrimaryColor"))
            .foregroundColor(Color.white)
            .opacity(disabled ? 0.5 : 1.0)
            .clipShape(Circle())
            .shadow(radius: 5)
            .overlay(
                        Group {
                            if loading {
                                ProgressView(
                                ).tint(Color.white)
                                    .controlSize(.large)
                            }
                        }
                    )
//            .rotationEffect(rotationAngle)  // Apply rotation effect using rotationAngle state
//            .onAppear() {
//                if loading {
//                    startRotating()  // Start rotating when loading
//                }
//            }
    }
    
    private func startRotating() {
        withAnimation(Animation.linear(duration: 1.0).speed(0.5).repeatForever(autoreverses: false)) {
            rotationAngle = .degrees(360)  // Rotate 360 degrees
        }
    }
}





struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ButtonView(
                icon: "chevron.left",
                disabled: false,
                onClick: {
                }, navigateTo:
                    AnyView(MainView()), loading: true
            )
        }
    }
}

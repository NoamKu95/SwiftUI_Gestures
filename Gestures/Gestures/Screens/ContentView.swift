//
//  ContentView.swift
//  Gestures
//
//  Created by Noam Kurtzer on 21/02/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isAnimation: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear // to stratch the ZStack to the whole height of the screen
                
                // MARK: image
                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2),radius: 12, x: 2, y: 2)
                    .opacity(isAnimation ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height) // DRAG gesture - actually move the image
                    .animation(.linear(duration: 1), value: isAnimation)
                    .scaleEffect(imageScale) // actually enlarge the image
                // MARK: DOUBLE TAP
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 { // image is regular size -> zoom in
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else { // image is enlarged -> return to normal
                            resetImageState()
                        }
                    })
                // MARK: DRAG gesture (catch user's dragging values)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)) {
                                    imageOffset = value.translation
                                }
                            }
                            .onEnded { _ in
                                if imageScale <= 1 { // if user made the image smaller
                                    resetImageState()
                                }
                            }
                    )
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                withAnimation(.linear(duration: 1)) {
                    isAnimation = true
                }
            })
            .overlay (
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                , alignment: .top
            )
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

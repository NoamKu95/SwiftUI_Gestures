//
//  ContentView.swift
//  Gestures
//
//  Created by Noam Kurtzer on 21/02/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var currentDisplayedPage: Page = pagesData[0]
    
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func updateDisplayedPage(newPage: Page) {
        isAnimating = true
        currentDisplayedPage = newPage
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear // to stratch the ZStack to the whole height of the screen
                
                // MARK: image
                Image(currentDisplayedPage.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2),radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height) // DRAG gesture - actually move the image
                    .animation(.linear(duration: 1), value: isAnimating)
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
                
                // MARK: MAGNIFICATION gesture
                    .gesture (
                        MagnificationGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value
                                    } else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            })
                            .onEnded({ _ in
                                if imageScale > 5 {
                                    imageScale = 5
                                } else if imageScale <= 1 {
                                    resetImageState()
                                }
                            })
                    )
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            })
            
            // MARK: INFO PANEL
            .overlay (
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                , alignment: .top
            )
            
            // MARK: CONTROLS
            .overlay(
                Group {
                    HStack {
                        Button {
                            withAnimation(.spring()) {
                                if imageScale > 1 {
                                    imageScale -= 1
                                } else if imageScale <= 1 {
                                    resetImageState()
                                }
                            }
                        } label: {
                            ControlImageView(iconName: "minus.magnifyingglass")
                        }
                        
                        Button {
                            resetImageState()
                        } label: {
                            ControlImageView(iconName: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        
                        Button {
                            withAnimation(.spring()) {
                                if imageScale < 5 {
                                    imageScale += 1
                                } else if imageScale > 5 {
                                    imageScale = 5
                                }
                            }
                        } label: {
                            ControlImageView(iconName: "plus.magnifyingglass")
                        }
                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
                    .padding(.bottom, 30)
                , alignment: .bottom
            )
            
            // MARK: DRAWER
            .overlay(
                DrawerView(isAnimating: isAnimating, drawerItemTappedAction: updateDisplayedPage)
                , alignment: .topTrailing
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

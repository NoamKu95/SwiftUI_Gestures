//
//  DrawerView.swift
//  Gestures
//
//  Created by Noam Kurtzer on 21/02/2023.
//

import SwiftUI

struct DrawerView: View {
    
    var isAnimating: Bool
    
    @State private var isDrawerOpen: Bool = false
    
    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 1
    
    @State var drawerItemTappedAction: ((_ newPage: Page) -> Void)
    
    var body: some View {
        HStack(spacing: 12) {
            
            // MARK: drawer icon
            Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .padding(8)
                .foregroundColor(.secondary)
                .onTapGesture(perform: {
                    withAnimation(.easeOut) {
                        isDrawerOpen.toggle()
                    }
                })
            
            // MARK: thumbnails
            ForEach(pages) { page in
                Image(page.thumbnailName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .opacity(isDrawerOpen ? 1 : 0)
                    .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                    .onTapGesture(perform: {
                        drawerItemTappedAction(page)
                    })
            }
            
            Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .opacity(isAnimating ? 1 : 0)
        .frame(width: 260)
        .padding(.top, UIScreen.main.bounds.height / 12)
        .offset(x: isDrawerOpen ? 20 : 215)
    }
}

struct DrawerView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerView(
            isAnimating: true,
            drawerItemTappedAction: {newPage in }
        )
    }
}

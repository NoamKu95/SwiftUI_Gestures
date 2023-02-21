//
//  InfoPanelView.swift
//  Gestures
//
//  Created by Noam Kurtzer on 21/02/2023.
//

import SwiftUI

struct InfoPanelView: View {
    
    var scale: CGFloat
    var offset: CGSize
    
    @State private var isInfoVisible: Bool = false
    
    var body: some View {
        HStack {
            // MARK: ICON
            Image(systemName: "circle.circle")
                .symbolRenderingMode(.hierarchical)
                .resizable()
                .frame(width: 30, height: 30)
                .onLongPressGesture(minimumDuration: 1) {
                        isInfoVisible = !isInfoVisible
                }
            
            Spacer()
            
            // MARK: INFO PANEL
            HStack (spacing: 2) {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                Text("\(scale)")
                
                Spacer()
                
                Image(systemName: "arrow.left.and.right")
                Text("\(offset.width)")
                
                Spacer()
                
                Image(systemName: "arrow.up.and.down")
                Text("\(offset.height)")

            }
            .font(.footnote)
            .padding(8)
            .background(.ultraThinMaterial) // gives the blury ios background
            .cornerRadius(8)
            .frame(maxWidth: 420)
            .opacity(isInfoVisible ? 1 : 0)
            .animation(.easeIn(duration: 0.5), value: isInfoVisible)
        }
    }
}

struct InfoPanelView_Previews: PreviewProvider {
    static var previews: some View {
        InfoPanelView(scale: 1, offset: .zero)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

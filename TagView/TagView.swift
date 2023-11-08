/***
 TagView.swift
 
 Created by Brian Batchelder on 11/7/23.
 Adapted from Kavsoft's ["SwiftUI Animated Tags View - Layout API - iOS 17 - Xcode 15"](https://www.patreon.com/posts/swiftui-animated-87032206)
*/

import SwiftUI

struct TagView: View {
    @State var tag: String
    @State var color: Color
    @State var icon: String
    //(_ tag: String, _ color: Color, _ icon: String) -> some View {
    var body: some View {
        HStack(spacing: 10) {
            Text(tag)
                .font(.callout)
                .fontWeight(.semibold)
            Image(systemName: icon)
        }
        .frame(height: 35)
        .foregroundStyle(.white)
        .padding(.horizontal, 15)
        .background {
            Capsule()
                .fill(color.gradient)
        }
    }
}


#Preview {
    TagView(tag: "Sample Tag", color: .green, icon: "checkmark")
}

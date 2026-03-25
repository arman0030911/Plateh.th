//
//  TagsView.swift
//  Plateh.th
//
//  Created by Adis on 9.03.2026.
//

import SwiftUI
struct InfoTagsView: View {
    var text: String 
    var body: some View {
        Text(text)
            .font(.appBody(14))
            .foregroundStyle(.appYelow)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.appBlack.opacity(0.18))
            .clipShape(Capsule())
            .overlay { 
                Capsule()
                    .stroke(.appYelow, lineWidth: 1)
            }
           
    }
}

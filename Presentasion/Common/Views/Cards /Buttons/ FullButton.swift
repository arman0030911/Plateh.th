//
//   FullButton.swift
//  Plateh.th
//
//  Created by Adis on 8.03.2026.
//

import SwiftUI

struct FullButton: View {
    var text: String 
    var filltcolor: Color
    var textcolor: Color
    var action: (() -> Void)?  
    var body: some View {
        Button { 
            action?()
        } label: { 
            Text(text)
                .font(.appBody(13))
                .foregroundStyle(filltcolor) 
                .padding(.vertical, 14)
                .frame(maxWidth:.infinity) 
                .background(textcolor)
                .clipShape(.capsule)
        }
        .buttonStyle(.plain)
 
        
    }
}

//
//  SolidButton.swift
//  Plateh.th
//
//  Created by Adis on 8.03.2026.
//

import SwiftUI

struct SolidButton:View {
    var text: String 
    var solidColor: Color
    var backRoundColor: Color = .appBlack
    var textColor: Color
    var isFull: Bool = false 
    var action: (() -> Void)?
    
    var body: some View {
        
        Button { 
            action?()
        } label: { 
            Text(text)
                .font(.appBody(13))
                .padding(.vertical, 14)
                .frame(maxWidth:.infinity)
                .foregroundStyle(isFull ? .appBlack: textColor)
                .background(isFull ? solidColor :backRoundColor)
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(solidColor, lineWidth: 1)
                }

        }
        .buttonStyle(.plain)

    }
}

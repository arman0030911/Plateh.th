//
//  RadioButtonView.swift
//  Plateh.th
//
//  Created by Adis on 9.03.2026.
//

import SwiftUI

struct RadioButtonView: View {
   @Binding var isSelected: Bool
    var body: some View {
        ZStack{
            Circle()
                .stroke(.appYelow, lineWidth: 2)
                .frame(width: 26)
            if isSelected {
                Circle()
                    .fill(.appYelow)
                    .frame(width: 12)
            }
        }
        .onTapGesture {
            isSelected.toggle()
        }
    }
}

//
//  Tabitem.swift
//  Plateh.th
//
//  Created by Adis on 13.03.2026.
//

import SwiftUI 
struct Tabitem: View {
    var image: String 
    var text: String 
    var pageType: TabPages
    @Binding var  selected: TabPages
    var body: some View {
        Button { 
            selected = pageType
        } label: { 
            VStack(spacing: 6){
               Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                Text(text)
                    .font(.appCaption(12))
            }
            .foregroundStyle(pageType == selected ? .appBlack : .appYelow)
            .padding(.vertical, 8)
            .padding(.horizontal,17)
            .background(pageType == selected ? .appYelow: .clear)
            .clipShape(RoundedRectangle(cornerRadius: 35))
            
        }
        .buttonStyle(.plain)

     
    }
}


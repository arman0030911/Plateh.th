import SwiftUI

struct FullButton: View {
    var text: String 
    var fillColor: Color
    var textcolor: Color
    var action: (() -> Void)?  
    var body: some View {
        Button { 
            action?()
        } label: { 
            Text(text)
                .font(.appBody(13))
                .foregroundStyle(fillColor) 
                .padding(.vertical, 13)
                .frame(maxWidth:.infinity) 
                .background(textcolor)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.controlRadius))
        }
        .buttonStyle(.plain)
    }
}

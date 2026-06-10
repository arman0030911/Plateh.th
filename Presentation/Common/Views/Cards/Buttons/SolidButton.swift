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
                .padding(.vertical, 13)
                .frame(maxWidth:.infinity)
                .foregroundStyle(isFull ? .appBlack: textColor)
                .background(isFull ? solidColor :backRoundColor)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.controlRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: AppTheme.controlRadius)
                        .stroke(solidColor, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
    }
}

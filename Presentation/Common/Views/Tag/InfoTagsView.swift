import SwiftUI
struct InfoTagsView: View {
    var text: String 
    var body: some View {
        Text(text)
            .font(.appBody(13))
            .foregroundStyle(.appYelow)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(AppTheme.elevatedSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallRadius))
            .overlay { 
                RoundedRectangle(cornerRadius: AppTheme.smallRadius)
                    .stroke(.appYelow.opacity(0.55), lineWidth: 1)
            }
    }
}

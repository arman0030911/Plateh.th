import SwiftUI

struct EmptyPaymentsView: View {
    var title: String
    var subtitle: String

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "tray")
                .font(.system(size: 30, weight: .medium))
                .foregroundStyle(.appMint.opacity(0.9))

            Text(title)
                .font(.appTitle(18))
                .foregroundStyle(.appYelow)

            Text(subtitle)
                .font(.appBody(14))
                .foregroundStyle(AppTheme.mutedText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .padding(.horizontal, 18)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardRadius))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.cardRadius)
                .stroke(AppTheme.border, lineWidth: 1)
        }
        .padding(.top, 18)
    }
}

import SwiftUI

struct DepositStateView: View {
    var title: String
    var subtitle: String
    var systemImage: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 30, weight: .medium))
                .foregroundStyle(.appMint.opacity(0.92))

            Text(title)
                .font(.appTitle(18))
                .foregroundStyle(.appYelow)
                .multilineTextAlignment(.center)

            Text(subtitle)
                .font(.appBody(14))
                .foregroundStyle(AppTheme.mutedText)
                .multilineTextAlignment(.center)

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.appBody(13))
                    .foregroundStyle(.appBlack)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(.appYelow)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.controlRadius))
                    .buttonStyle(.plain)
            }
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

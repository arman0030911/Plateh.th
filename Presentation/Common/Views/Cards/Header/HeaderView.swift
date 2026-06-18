import SwiftUI

struct HeaderView: View {
    var page: HeaderViewContent
    var action: (() -> Void)?
    @Binding var date: Date?

    @State private var isShowCalendar: Bool = false
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                // Top row: hamburger (left) and action button (right)
                HStack {
                    MenuButton(isOpen: $appState.isSideMenuOpen)

                    Spacer()

                    if (page.pageType == .main || page.pageType == .deposit), action != nil {
                        Button {
                            action?()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.appYelow)
                                    .frame(width: 38, height: 38)
                                Image(systemName: "plus")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.appBlack)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(page.totalPrice)
                            .font(.appDisplay(32))
                            .foregroundStyle(.appGray)

                        Text(page.title)
                            .font(.appTitle(28))
                    }

                    HStack {
                        Spacer()
                        if page.pageType == .paymentList {
                            Button {
                                isShowCalendar = true
                            } label: {
                                Image(systemName: "calendar")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 23, height: 23)
                                    .foregroundStyle(.appYelow)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("Tarih seç")
                        }
                    }

                    Text(page.date)
                        .font(.appCaption(15))
                        .foregroundStyle(.appMint)
                }
            }
            .foregroundStyle(.appYelow)
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 16)
            .background(
                LinearGradient(
                    colors: [
                        .appBlack,
                        .appBlack.opacity(0.94)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            if isShowCalendar {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowCalendar = false
                    }

                VStack(spacing: 12) {
                    let nonOptionalDate = Binding<Date>(
                        get: { date ?? Date() },
                        set: { newValue in
                            date = newValue
                        }
                    )

                    DatePicker("", selection: nonOptionalDate, displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .padding(8)
                        .background(Color.clear)
                        .scaleEffect(0.95)
                        .onChange(of: nonOptionalDate.wrappedValue) { _ in
                            isShowCalendar = false
                        }
                }
                .padding(16)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardRadius))
                .padding(.horizontal, 24)
                .shadow(color: .black.opacity(0.25), radius: 20, y: 12)
            }
        }
    }
}

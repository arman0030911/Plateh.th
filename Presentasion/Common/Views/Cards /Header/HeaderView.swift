//
//  MainHeaderView.swift
//  Plateh.th
//
//  Created by Adis on 5.03.2026.
//

import SwiftUI

struct HeaderView: View {
    var page: HeaderViewContent
    var action: (() -> Void)?
    @Binding var date: Date?

    @State private var isShowCalendar: Bool = false

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(page.totalPrice)
                        .font(.appDisplay(34))
                        .foregroundStyle(.appGray)
                    Spacer()

                    if page.pageType == .main {
                        Button {
                            action?()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(.appYelow)
                                    .frame(width: 36, height: 36)
                                Image(systemName: "plus")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(.appBlack)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(page.title)
                            .font(.appTitle(30))
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
                }

                Text(page.date)
                    .font(.appCaption(15))
                    .foregroundStyle(.appMint)
                    .padding(.top, 2)
            }
            .foregroundStyle(.appYelow)
            .padding(.horizontal, 24)
            .padding(.top, 14)
            .padding(.bottom, 14)
            .background(.appBlack)

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
                        .onChange(of: nonOptionalDate.wrappedValue) { _, _ in
                            isShowCalendar = false
                        }
                }
                .padding(16)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 24)
                .shadow(color: .black.opacity(0.25), radius: 20, y: 12)
            }
        }
    }
}

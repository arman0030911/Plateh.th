
import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: AddViewModel = Assembly.createAddViewModel()

    // MARK: - Body

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 27) {
                Text("Ödeme ekle")
                    .font(.appTitle(20))
                    .foregroundStyle(.appYelow)

                if !viewModel.isAdded {
                    addViewContent
                } else {
                    Spacer()
                    successView
                    Spacer()
                }

            }
            .padding(.horizontal, AppTheme.screenPadding)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
            .background(.appBlack)

            if viewModel.isShowCalendar {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.isShowCalendar = false
                    }

                VStack(spacing: 12) {
                    DatePicker("", selection: $viewModel.date, displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .padding(8)
                        .background(Color.clear)
                        .scaleEffect(0.85)
                        .onChange(of: viewModel.date) { _ in
                            viewModel.isShowCalendar = false
                        }

                }
                .padding(16)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardRadius))
                .padding(.horizontal, 24)
            }
        }
        .onChange(of: viewModel.isAdded) { isAdded in
            guard isAdded else { return }

            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.9))
                dismiss()
            }
        }
    }
}
extension AddView {
    // MARK: - Content

    var addViewContent: some View {
        VStack(alignment: .center, spacing: 27) {
            VStack(alignment: .leading, spacing: 25) {
                HStack(spacing: 23) {
                    SolidButton(text: "Her ay", solidColor: .appYelow, textColor: .appYelow, isFull: viewModel.payType == .monthly) {
                        viewModel.payType = .monthly
                    }
                    SolidButton(text: "Tek sefer", solidColor: .appYelow, textColor: .appYelow, isFull: viewModel.payType == .oneTime) {
                        viewModel.payType = .oneTime
                    }
                }

                switch viewModel.payType {
                case .monthly:
                    HStack(spacing: 5) {
                        Button {
                            viewModel.isShowCalendar.toggle()
                        } label: {
                            Text(viewModel.date.shortTurkishDisplay)
                                .font(.appBody(16))
                                .foregroundStyle(.appMint)
                                .underline()
                        }
                        .buttonStyle(.plain)
                    }

                case .oneTime:
                    HStack(spacing: 5) {
                        Text("Son tarih")
                            .font(.appBody(14))
                            .foregroundStyle(.appMint)
                        Button {
                            viewModel.isShowCalendar.toggle()
                        } label: {
                            Text(viewModel.date.shortTurkishDisplay)
                                .font(.appBody(16))
                                .foregroundStyle(.appMint)
                                .underline()
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical)
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                switch viewModel.payType {
                case .monthly:
                    HStack(spacing: 10) {
                        FieldView(text: $viewModel.totalAmount, placeholder: "Toplam tutar",isTextPrice: true)
                        FieldView(text:$viewModel.paymentAmount, placeholder: "Aylık ödeme", isTextPrice: true)
                    }
                case .oneTime:
                        FieldView(text: $viewModel.totalAmount, placeholder: "Toplam tutar",isTextPrice: true)
                }

                FieldView(text:$viewModel.paymentName, placeholder: "Ödeme adı")
                FieldView(text: $viewModel.description, placeholder: "Açıklama", isTextField: false)
            }
            .padding(14)
            .background(AppTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardRadius))
            .overlay {
                RoundedRectangle(cornerRadius: AppTheme.cardRadius)
                    .stroke(AppTheme.border, lineWidth: 1)
            }

            HStack {
                Text("Ödeme bildirimi")
                    .font(.appBody(14))
                    .foregroundStyle(AppTheme.mutedText)
                    .offset(y: -4)
                Spacer()
                RadioButtonView(isSelected: $viewModel.isNotificationSelected)
            }
            .padding(.horizontal, 10)

            if let validationMessage = viewModel.validationMessage {
                Text(validationMessage)
                    .font(.appCaption(12))
                    .foregroundStyle(.appRed)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)
            }

            Spacer()
            FullButton(text: "Ekle", fillColor: .black, textcolor: .appYelow) {
                viewModel.createNewPayment()
            }
            .disabled(!viewModel.canCreatePayment)
            .opacity(viewModel.canCreatePayment ? 1 : 0.55)
        }
    }
}

extension AddView {
    var successView: some View {
        VStack(spacing: 55) {
            Image(systemName: "checkmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 104, height: 104)
                .foregroundStyle(.appYelow)
            Text("Ödeme eklendi")
                .font(.appTitle(22))
                .foregroundStyle(.appYelow)
        }
    }
}

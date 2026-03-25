
import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: AddViewModel = Assembly.createAddViewModel()

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
                    addSucsess
                    Spacer()
                }

            }
            .padding(.horizontal, 18)
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
                    // Графический календарь, прозрачный контейнер, маленький размер
                    DatePicker("", selection: $viewModel.date, displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .padding(8)
                        .background(Color.clear)
                        .scaleEffect(0.85)
                        .onChange(of: viewModel.date) { _, _ in
                            viewModel.isShowCalendar = false
                        }

                }
                .padding(16)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 24)
            }
        }
        .onChange(of: viewModel.isAdded) { _, isAdded in
            guard isAdded else { return }

            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.9))
                dismiss()
            }
        }
    }
}



extension AddView {
    var addViewContent: some View {
        VStack(alignment: .center, spacing: 27) {
            VStack(alignment: .leading, spacing: 25) {
                HStack(spacing: 23) {
                    SolidButton(text: "Her ay", solidColor: .appYelow, textColor: .appYelow, isFull: viewModel.payType == .mounthly) {
                        viewModel.payType = .mounthly
                    }
                    SolidButton(text: "Tek sefer", solidColor: .appYelow, textColor: .appYelow, isFull: viewModel.payType == .oneTime) {
                        viewModel.payType = .oneTime
                    }
                }

                switch viewModel.payType {
                case .mounthly:
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
                case .mounthly:
                    HStack(spacing: 10) {
                        FieldView(text: $viewModel.totalAmount, placeholder: "Toplam tutar",isTextPrice: true)
                        FieldView(text:$viewModel.paymanetAmount, placeholder: "Aylık ödeme", isTextPrice: true)
                    }
                case .oneTime:
                        FieldView(text: $viewModel.totalAmount, placeholder: "Toplam tutar",isTextPrice: true)
                }

                FieldView(text:$viewModel.paymentName, placeholder: "Ödeme adı")
                FieldView(text: $viewModel.description, placeholder: "Açıklama", isTextField: false)
            }

            HStack {
                Text("Ödeme bildirimi")
                    .font(.appBody(14))
                    .foregroundStyle(.appYelow)
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
            FullButton(text: "Ekle", filltcolor: .black, textcolor: .appYelow) {
                viewModel.createNewPayment()
            }
            .disabled(!viewModel.canCreatePayment)
            .opacity(viewModel.canCreatePayment ? 1 : 0.55)
        }
    }
}

extension AddView {
    var addSucsess: some View {
        VStack(spacing: 55) {
            Image(systemName: "checkmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 127, height: 127)
                .foregroundStyle(.appYelow)
            Text("Ödeme eklendi")
                .font(.appTitle(22))
                .foregroundStyle(.appYelow)
        }
    }
}

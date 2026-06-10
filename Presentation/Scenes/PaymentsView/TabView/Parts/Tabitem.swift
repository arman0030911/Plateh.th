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
            HStack(spacing: 7){
               Image(systemName: image)
                    .font(.system(size: 14, weight: .semibold))
                Text(text)
                    .font(.appCaption(12))
            }
            .foregroundStyle(pageType == selected ? .appBlack : .appYelow)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 11)
            .background(pageType == selected ? .appYelow: .clear)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

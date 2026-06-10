import SwiftUI 
 

struct MainTabView: View {
    @State var selectionPage: TabPages = .main
    @Binding var path: NavigationPath
    
    init(path: Binding <NavigationPath>) { 
        UITabBar.appearance().isHidden = true
        self._path = path 
    }
    var body: some View {
        ZStack(alignment:.bottom ){
            TabView(selection: $selectionPage) { 
                ContentView(path: $path)
                    .tag(TabPages.main)
                PaymentsView(path: $path)
                    .tag(TabPages.paymentList)
                
                DepositView()
                    .tag(TabPages.deposit)
            }
            
            HStack(spacing: 10){
                Tabitem(image: "house", text:"Ana sayfa", pageType: .main , selected: $selectionPage)
                Tabitem(image: "list.bullet.rectangle.portrait", text:"Ödemeler", pageType: .paymentList, selected: $selectionPage)
                Tabitem(image: "percent", text:"Faiz", pageType: .deposit, selected: $selectionPage)
            }
            .padding(.horizontal, 10)
            .frame(maxWidth:.infinity)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial.opacity(0.18))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardRadius))
            .overlay {
                RoundedRectangle(cornerRadius: AppTheme.cardRadius)
                    .stroke(AppTheme.border, lineWidth: 1)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        } 
    }
}

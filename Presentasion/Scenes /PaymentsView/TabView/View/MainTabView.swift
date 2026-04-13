//
//  MainTabView.swift
//  Plateh.th
//
//  Created by Adis on 5.03.2026.
//

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
            //.padding(.bottom, 120 )
            
            HStack(spacing: 32){
                Tabitem(image: "house", text:"Ana sayfa", pageType: .main , selected: $selectionPage)
                Tabitem(image: "list.bullet.rectangle.portrait", text:"Ödemeler", pageType: .paymentList, selected: $selectionPage)
                
                Tabitem(image: "list.bullet.rectangle.portrait", text:"Faiz", pageType: .deposit, selected: $selectionPage)
             
                 
            }
            .padding(.horizontal, 18)
            .frame(maxWidth:.infinity)
            .padding(.top, 16)
            .padding(.bottom, 10)
            .background(.ultraThinMaterial.opacity(0.12))
            .clipShape(Capsule())
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        } 
         
    }
}


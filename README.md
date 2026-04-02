# Plateh.th

Aylık ve tek seferlik ödemeler için iOS borç/ödeme takip uygulaması.

## Ekran Görüntüleri


## Mimari
- **Clean Architecture** (Domain, Data, Presentation katmanları)
- **MVVM** deseni (Model-View-ViewModel)  
- **Dependency Injection** (Assembly ile bağımlılık enjeksiyonu)

## Teknolojiler
- SwiftUI
- Core Data (veri kalıcılığı/yerel depolama)
- Combine (@Published, ObservableObject)
- Swift Concurrency (async/await)

## Özellikler
- ✅ Ödeme ekleme (aylık/tek seferlik - mounthly/oneTime)
- ✅ Kalan borç miktarını takip etme
- ✅ Ödeme bildirimleri
- ✅ Yerel veri depolama (Core Data)

## Kurulum
1. Repositoriyi klonlayın
2. `Plateh.th.xcodeproj` dosyasını Xcode 15+'da açın
3. Simülatörde veya cihazda çalıştırın

## Neler Öğrendim
- iOS'ta Clean Architecture kullanımı (Katmanlı mimari)
- SwiftUI'de state yönetimi (ObservableObject, @Published)
- Core Data'da threading sorunlarını çözme (DispatchQueue, perform)
- SwiftUI NavigationStack kullanımı
- Hashable protokolü ve tarih (Date) verilerinde dikkat edilmesi gerekenler

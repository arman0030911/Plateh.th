# Plateh.th

Plateh.th, düzenli ödemeleri ve tek seferlik borçları takip etmeyi kolaylaştıran, aynı zamanda bankaların mevduat faiz oranlarını karşılaştırmalı olarak gösteren bir iOS uygulamasıdır.

## Proje Özeti

Uygulama iki ana ihtiyacı bir araya getirir:
- aylık ve tek seferlik ödemeleri tek yerden yönetmek,
- farklı bankaların faiz oranlarını karşılaştırarak yatırım kararını desteklemek.

Bu proje, staj başvurusu için gerçek ürün mantığına sahip bir SwiftUI uygulaması olarak tasarlanmıştır. Sadece ekran üretmek yerine veri kalıcılığı, iş kuralları, durum yönetimi ve istemci-sunucu iletişimi birlikte ele alınmıştır.

## Temel Özellikler

- Aylık ve tek seferlik ödeme ekleme
- Kalan borç tutarını ve ödeme durumunu takip etme
- Yerel bildirimlerle ödeme hatırlatma
- Tamamlanan ve aktif kayıtları ayıran ödeme akışı
- Banka faiz oranlarını sunucudan çekme
- Tutar ve vade bazlı yatırım hesaplama

## Mimari

- **Clean Architecture**  
  Domain, Data ve Presentation katmanları ayrılmıştır.
- **MVVM**  
  Ekran mantığı ViewModel katmanında toplanmıştır.
- **Dependency Injection**  
  Bağımlılıklar `Assembly` üzerinden oluşturulur.
- **Core Data**  
  Ödeme kayıtları ve uygulama içi durum kalıcı olarak saklanır.
- **Client-Server yapı**  
  Faiz modülü, lokal çalışan REST API üzerinden gerçek verileri alır.

## Teknolojiler

- SwiftUI
- Core Data
- Swift Concurrency
- Combine
- Vapor
- PostgreSQL
- UserNotifications

## Faiz Modülü

Faiz sekmesi, backend üzerinden gelen mevduat oranlarını kart yapısında gösterir.

- para birimi ve vade filtresi
- banka bazlı oran kartları
- beklenen getiri ve vade sonu toplam hesaplama
- lokal sunucuya bağlı canlı veri akışı

## iOS Uygulamasını Çalıştırma

1. Repoyu klonlayın.
2. `Plateh.th.xcodeproj` dosyasını Xcode ile açın.
3. Gerekirse lokal API adresini `DepositService` içinde kontrol edin.
4. Uygulamayı simülatörde veya cihazda başlatın.

## Lokal Sunucuyu Çalıştırma

Faiz verileri ayrı bir Vapor + PostgreSQL servisinden gelir.

1. PostgreSQL servisinin çalıştığından emin olun.
2. Vapor sunucusunu başlatın.
3. API'nin `localhost:8080` üzerinden erişilebilir olduğunu doğrulayın.
4. Ardından iOS istemcisini çalıştırın.

## Bu Proje Neden Güçlü Bir Staj Projesi?

Bu proje sadece görsel arayüzden oluşmaz. Aşağıdaki başlıkları birlikte gösterir:

- ürün düşüncesi ve kullanıcı akışı
- katmanlı mimari yaklaşımı
- Core Data ile kalıcı veri yönetimi
- tarih ve ödeme durumu gibi iş kuralları
- istemci ile sunucu arasında gerçek veri iletişimi
- kullanıcıya yönelik finansal bilgi sunumu

## Geliştirme Notları

- Ödeme modülü çevrimdışı senaryolara uygundur.
- Faiz modülü backend verisine göre genişletilebilir yapıdadır.
- Proje, yeni banka ve oran senaryolarına açık olacak şekilde hazırlanmıştır.

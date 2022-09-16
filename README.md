# MovieApplication

## Base Katmanların Oluşturulması
Öncelik ile network ve model sayfalarını oluşturdum. Network katmanını generic yazdım ve bu sayede kod kalabalığından kurtulup daha temiz bir yapı ortaya çıktı.
Uygulamaya kütüphane eklerken Cocoapods ve SPM kullandım.

## Ana Sayfa 
- Tasarımını oluşturduğum ana sayfada ViewModel oluşuturup network katmanında kurduğum yapı ile gerekli yere istek atıp dönen sonucu View'de gösterdim.
Burada yukarıda slider yapısı oluşturdum ve 4 saniyede bir kendiliğinden bir geçiş sağladım. Sliderda benden istenildiği gibi şuan yayında olan filmler listelenmektedir.

- Liste olarak gördüğümüz yerde pagination yapısı kullanarak yaptım ve hepsini birden yüklemek yerine sayfa sayfa yüklemekte bu sayede uygulama daha performanslı olmuştur.
Benden istenildiği gibi listede yakın zamanda vizyona girecek filmleri listeledim.
Son olarak Pull to reflesh özelliği bulunmaktadır.

![Screen Shot 2022-09-16 at 10 55 -2](https://user-images.githubusercontent.com/62101026/190589280-1d3c76f9-b7e5-41ce-89df-2208bc053e61.png)


## Detay Sayfası
Listedeki filimlerin detaylarını burada görebilmekteyiz.

![Screen Shot 2022-09-16 at 10 55](https://user-images.githubusercontent.com/62101026/190589992-93c8fc70-0bf1-440c-898d-265f67def958.png)

## Kullandığım Teknolojiler
- KingFisher
- SnapKit
- UIkit Programmatically
- Storyboards
- MVVM Mimarisine uygun yazılmıştır

### Ek Bilgi

Uygulamayı geliştirirken bir çok şeyi birlikte kullanmaya özen gösterdim. Cocoapods ve SPM ikisine de yetkinliğim olduğunu göstermek istedim. 
Ana sayfayı geliştirirken Programatik kodlama ile geliştirdim ancak detay sayfasını Stroyboard ile geliştirdim burada da amacım ikisinede yetkinliğim olduğunu gösterebilmekti.
Temiz kod yazmaya özen gösterdim ve MVVM mimarisene uygun bir şekilde geliştirme yaptım.

## Uygulama Ön İzlemesi




https://user-images.githubusercontent.com/62101026/190590975-a64710e7-f887-49c3-9b5e-fd47bec9ce1e.mp4





import 'package:flutter/material.dart';

class About extends StatefulWidget {
  final String aboutTitle ='UYGULAMA\nHAKKINDA';
  final String purposeTitle ='Uygulamanın Amacı';
  final String purposeText = 'Bu uygulama, Seyit Ahmet Gökçe tarafından Kırıkkale Üniversitesi Bilgisayar Mühendisliği Bölümü 2020-2021 eğitim-öğretim yılı 3. sınıf 1. dönem "Proje-1" dersinin projesi olarak yapılmıştır.';
  final String appearanceTitle ='Uygulamanın İşlevleri';
  final String appearanceText = 'Bu uygulamanın işlevlerini şu şekilde sıralayabiliriz:\n\n-Devamsızlık Takibi: Bu uygulamaya, girdiğiniz ders bilgileriyle birlikte devamsızlık kaydınızı da girebilirsiniz. Dilerseniz her gün belirlediğiniz saatte uygulamanın size, o günkü devamsızlık kaydını girmenizi hatırlatması için ilgili ayarı aktif edebilirsiniz. Eğer ilgili eğitim kurumunun online eğitim sisteminden bir API desteği alınabilirse devamsızlık kaydı otomatik olarak tutulabilir.\n\n-Ders Programı: Uygulama, sizin girdiğiniz derslerin zaman bilgilerini kullanarak bir ders programı oluşturur. Dilerseniz ders için zaman bilgisi girmeden de o dersi ekleyebilirsiniz. Bu durumda o ders, ders programında "Zamanı Belirtilmemiş Dersler" kısmında görüntülenir.\n\n-Yaklaşan Online Dersler: Bu özelliğin amacı, okuduğunuz kurumun online eğitim sistemiyle uyumlu çalışarak kullanıcıya bir arayüzde yaklaşan online derslerin bilgilerini sunmaktır. Bu özelliğin kullanıma açılabilmesi için, ilgili eğitim kurumunun online eğitim sisteminden bir API desteğinin bu uygulamaya sağlanması gerekmektedir.\n\n-Geçmiş Online Dersler: Bu özelliğin amacı, okuduğunuz kurumun online eğitim sistemiyle uyumlu çalışarak kullanıcıya bir arayüzde geçmiş online derslerin bilgilerini sunmaktır. Bu özelliğin kullanıma açılabilmesi için, ilgili eğitim kurumunun online eğitim sisteminden bir API desteğinin bu uygulamaya sağlanması gerekmektedir.\n\n-Ders Hatırlatıcısı: Bu uygulamanın size, dersten belirlediğiniz kadar dakika önce bir hatırlatma yapmasını talep edebilirsiniz.\n\nÜniversite Seçme ve Üniversiteye Özel Ayarlar: Okuduğunuz eğitim kurumunu seçerek uygulamanın, online derslerinize hangi yöntemle erişeceğini bilmesini sağlarsınız. Bir eğitim/öğretim kurumunun online eğitim sisteminden API desteği almamız durumunda bu özelliği aktifleştireceğiz.';
  final String personalDataTitle = 'KİŞİSEL VERİLER HAKKINDA';
  final String personalDataText ='Bu uygulama, online eğitim sistemiyle iletişim kurabilmek için sizin bilgilerinize ihtiyaç duyar. Bu veriler yalnızca cihazınızda kalır ve bir havuzda toplanmaz ya da işlenmez.';
  final String unresponsibilityTitle = 'SORUMLULUK REDDİ BEYANI';
  final String unresponsibilityText = 'Bu uygulama, işleri kolaylaştırmak için yapıldı. Ders zamanı ya da bildirimi, ders programı, uygulama içi hata kaynaklı program aksamaları ve bunun dersteki devam - takip durumuna yansıması, uygulamanın kaynak kodlarına ya da kaynak dosyalarına erişilerek bunların değiştirilmesi durumunda oluşacak sorunlar, bellekte tutulan bilgilerin ve kalıcı/geçici dosyaların değiştirilmesi nedeniyle oluşacak sorunlar da dahil tüm durumlarda doğacak zararlardan geliştirici hiçbir şekilde sorumluluk kabul etmez. Lütfen bir hata bulmanız halinde geliştiriciye bu hatayı bildiriniz. Teşekkürler.';
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hakkında",
          style: TextStyle(
            fontFamily: "Comfortaa-Bold",
          ),
        ),
      ),
      body:  Center(
        child: Column(
          children: [
            SizedBox(height: 8,),
            Container(
              width: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.height - 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.black87,
                    width: 2
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 16,),
                      Text(
                        widget.aboutTitle,
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: "Comfortaa-Bold",
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16,),
                      Text(
                        widget.purposeTitle,
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: "Comfortaa-Bold",
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16,),
                      Text(
                        widget.purposeText,
                        style: TextStyle(
                          //fontSize: 25,
                          fontFamily: "Comfortaa-Light",
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 16,),
                      Text(
                        widget.appearanceTitle,
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: "Comfortaa-Bold",
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16,),
                      Text(
                        widget.appearanceText,
                        style: TextStyle(
                          //fontSize: 25,
                          fontFamily: "Comfortaa-Light",
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 16,),
                      Text(
                        widget.personalDataTitle,
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: "Comfortaa-Bold",
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16,),
                      Text(
                        widget.personalDataText,
                        style: TextStyle(
                          //fontSize: 25,
                          fontFamily: "Comfortaa-Light",
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 16,),
                      Text(
                        widget.unresponsibilityTitle,
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: "Comfortaa-Bold",
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16,),
                      Text(
                        widget.unresponsibilityText,
                        style: TextStyle(
                          //fontSize: 25,
                          fontFamily: "Comfortaa-Light",
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

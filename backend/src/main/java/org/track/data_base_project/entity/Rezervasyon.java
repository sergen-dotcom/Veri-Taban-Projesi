package org.track.data_base_project.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;


@Table(name = "Rezervasyon") 
@Entity  
@Getter 
@Setter 
@NoArgsConstructor 

public class Rezervasyon {
    @Id//tablonun primary keyidir. 
    @GeneratedValue(strategy = GenerationType.IDENTITY)//MySQL id +1 ekler auto_increment.
    @Setter(AccessLevel.NONE)//id ler dışarıdan manuel değiştirilmez.
    private Integer id;

    @ManyToOne(fetch=FetchType.LAZY)//misafirin birden fazla rezervasyon yapmasıdır (FetchType.LAZY ise performansı arttırır misafir rezervasyonunu çektiği zaman misafiri sorgular)
    @JoinColumn(name="misafir_id" , nullable = false)//veritabanında ki bağlantıyı "misafir_id" deriz.
    private Misafir misafir;

    @ManyToOne (fetch = FetchType.LAZY)//bir oda farklı zamanlarda birden fazla rezervasyon alabilir  hafta , ay , yıl 
    @JoinColumn(name="oda_id",nullable = false)
    private Oda oda;

    @Column(name="giris_tarihi" , nullable = false)//misafir otele giriş yapar.
    private LocalDate girisTarihi;//LocalDate saati çağırır.

    @Column(name="cikis_tarihi" , nullable = false)//misafir otelden ayrılır.
    private LocalDate cikisTarihi;

    @Column (name = "kisi_sayisi" , nullable = false)//odada kalacak kişi sayısı
    private Integer kisiSayisi;

    @Column(name="anlasilan_fiyat" , nullable=false , precision = 10 , scale = 2)//1 gece de ne kadar ödiyeceğiniz. precision görevi en fazla 10 basamak olabilir sclae ise virgülden sonra 2 basamak
    private BigDecimal anlasilanFiyat;

    @Enumerated(EnumType.STRING) //veritabanındaki metinle eşleşicek başlangıçta beklemede olucak
    @Column(name = "durum", nullable =false)
    private Durum durum = Durum.beklemede ;// durum başlangıçta beklemede olucak (beklemede , onaylı , iptal , tamamlandı)

    @Column(name="olusturma_tarihi" , updatable = false)
    private LocalDateTime olusturmaTarihi;

    @PrePersist// veritabanına INSERT edilirken çalışır ve anlık zamanı kullanır. 
    protected void onCreate(){
        this.olusturmaTarihi=LocalDateTime.now();
    }

    //Özel constructor (sisteme yeni rezervasyon yapılırken id ve oluşturma tarihi hariç)
    public Rezervasyon(Misafir misafir , Oda oda , LocalDate girisTarihi , LocalDate cikisTarihi , Integer kisiSayisi , BigDecimal anlasilanFiyat , Durum durum){
        this.misafir=misafir;
        this.oda=oda;
        this.girisTarihi=girisTarihi;
        this.cikisTarihi=cikisTarihi;
        this.kisiSayisi=kisiSayisi;
        this.anlasilanFiyat=anlasilanFiyat;
        this.durum=(durum != null)? durum: Durum.beklemede; //null kontrolü sağladık bu sayede varsayılan olan beklemedeyi koruduk
    }

    public enum Durum{
        beklemede,
        onaylı,
        iptal,
        tamamlandı
    }
}

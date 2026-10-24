package org.track.data_base_project.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDateTime;

@Entity
@Table(name = "IslemLog")
@Getter
@Setter
@NoArgsConstructor

public class IslemLog {
    @Id 
    @GeneratedValue(strategy = GenerationType.IDENTITY) 
    @Setter(AccessLevel.NONE) 
    private Integer id;

    @Column(name="tablo_adi" , nullable=false , length = 50)//hangi tabloda işlem yapılıcak örneğin rezervasyon , oda , misafir
    private String tabloAdi;

    @Enumerated(EnumType.STRING)//islem_turu enum ekleme , guncelleme , silme
    @Column(name="islem_turu" , nullable = false)
    private IslemTuru islemTuru;

    @Column(name = "kayit_id" , nullable = false)//işlem gören kaydın primary keyi
    private Integer kayitId;

    @Column(name = "eski_deger" , columnDefinition = "TEXT")//değişiklikten önceki eski durumu TEXT nedeni uzun içerikler için kullanılır.
    private String eskiDeger;

    @Column(name="yeni_deger" , columnDefinition ="TEXT")//değişiklikten sonra ki yeni durum
    private String yeniDeger;

    @Column(name = "zaman" , updatable = false)//log kaydının düştüğü zaman.
    private LocalDateTime zaman;

    
    @PrePersist//kayıt oluşturulduğu anda sistem saatini otomatik basar
    protected void onLog() {
        this.zaman = LocalDateTime.now();
    }

    //özel constructor yeni log kaydı oluştururken kullanmak için
    public IslemLog(String tabloAdi, IslemTuru islemTuru, Integer kayitId, String eskiDeger, String yeniDeger) {
        this.tabloAdi = tabloAdi;
        this.islemTuru = islemTuru;
        this.kayitId = kayitId;
        this.eskiDeger = eskiDeger;
        this.yeniDeger = yeniDeger;
    }

    public enum IslemTuru {
        ekleme,
        guncelleme,
        silme
    }
}

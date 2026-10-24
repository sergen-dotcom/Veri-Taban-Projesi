package org.track.data_base_project.entity;

import lombok.AccessLevel;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Table(name = "HizmetEnvanter") 
@Entity 
@Getter 
@Setter 
@NoArgsConstructor 


public class HizmetEnvanter {

    @Id// ayrı bir auto_increment yerine doğrudan hizmet_id primary key / foreign key olarak kullanılmıştır.
    @Column(name = "hizmet_id")//id alanını EkHizmetin birincil anahtarıyla birebir eşleştiriyoruz.
    @Setter(AccessLevel.NONE) //id değerini dışardan elle değiştirilmesini engeller
    private Integer id;

    @OneToOne(fetch = FetchType.LAZY)// EkHizmet ile 1-1 ilişki kurarız.
    @MapsId//@MapsId sayesinde EkHizmetin id si bu tablonun idsine kopyalanır.
    @JoinColumn(name = "hizmet_id")
    private EkHizmet ekHizmet;

    @Column(name = "stok_miktari", nullable = false) // ek hizmete ait stok adedi minibardaki su, havlu, bornoz.
    private Integer stokMiktari = 0;

    // Özel constructor (yeni envanter tanımı açarken kullanmak için)
    public HizmetEnvanter(EkHizmet ekHizmet, Integer stokMiktari) {
        this.ekHizmet = ekHizmet;
        this.stokMiktari = (stokMiktari != null) ? stokMiktari : 0;
    }
}

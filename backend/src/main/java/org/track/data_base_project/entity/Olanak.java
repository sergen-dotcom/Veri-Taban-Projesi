package org.track.data_base_project.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "Olanak")
@Getter
@Setter
@NoArgsConstructor

public class Olanak {
    @Id//tablonun birincil anahtarı primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY)//MySQL AUTO_INCREMENT özelliği +1 artar
    @Setter(AccessLevel.NONE)//ID dışarıdan değiştirlmez.
    private Integer id;

    @Column(name = "ad" , nullable = false , unique = true , length = 50) //Wi-Fi , jakuzi , balkon vb.
    private String ad;

    public Olanak(String ad) {
        this.ad = ad;
    }
}

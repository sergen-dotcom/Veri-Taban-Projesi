create database hastane;
use hastane;

create table poliklinikler(
	id int auto_increment primary key,
    ad varchar(50) not null
);

create table servisler(
	id int auto_increment primary key,
    servis_adi varchar(50) not null,
    poliklinik_id int not null,
    foreign key (poliklinik_id) references poliklinikler(id)
);

create table doktorlar(
	id int auto_increment primary key,
    ad_soyad varchar(60) not null,
    brans varchar(50),
    poliklinik_id int not null,
    foreign key (poliklinik_id) references poliklinikler(id)
);

create table hemsireler(
	id int auto_increment primary key,
    ad_soyad varchar(60) not null,
    servis_id int not null,
    foreign key (servis_id) references servisler(id)
);

create table tahliller(
	id int auto_increment primary key,
    tc char(11) not null unique,
    ad_soyad varchar(60) not null,
    telefon varchar(15),
    dogum_tarihi date
);

create table hastalar(
	id int auto_increment primary key,
    tc char(11) not null unique,
    ad_soyad varchar(60) not null,
    telefon varchar(15),
    dohum_tarihi date
);

create table muayeneler(
	id int auto_increment primary key,
    hasta_id int not null,
    poliklinik_id int not null,
    doktor_id int not null,
    tarih datetime default current_timestamp,
    foreign key (hasta_id) references hastalar(id),
    foreign key (poliklinik_id) references poliklinikler(id),
    foreign key (doktor_id) references doktorlar(id)
);

create table tahlil_kayitlari(
	id int auto_increment primary key,
    hasta_id int not null,
    doktor_id int not null,
    tahlil_id int not null,
    istek_tarihi datetime default current_timestamp,
    sonuc varchar(255),
    foreign key(hasta_id)references hastalar(id),
    foreign key(doktor_id)references doktorlar(id),
    foreign key(tahlil_id)references tahliller(id)
);
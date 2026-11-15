# Database Wisata Indonesia

Kerangka database PostgreSQL + PostGIS untuk website Sistem Pendukung
Keputusan (SPK) destinasi wisata di Indonesia.

## Isi repo
- schema.sql : struktur database (tabel, relasi, indeks)
- erd.png    : diagram relasi antar tabel

## Tabel
- categories, subcategories : kategori dan subkategori wisata
- provinces, regencies, districts : wilayah (provinsi > kabupaten/kota > kecamatan)
- destinations : data destinasi wisata (termasuk koordinat PostGIS)

## Cara pakai
1. Install PostgreSQL dan aktifkan ekstensi PostGIS
2. Buat database baru bernama wisata_indonesia
3. Jalankan schema.sql di pgAdmin (Query Tool)
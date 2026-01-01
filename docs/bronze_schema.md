# Bronze Layer – Raw Schema Design (As-Is)

## Tujuan
Mendefinisikan struktur tabel raw (Bronze Layer) yang merepresentasikan
data mentah dari source system pelayanan kesehatan dan KIA tanpa transformasi.

---

## Daftar Source System
- Sistem Pelayanan Kesehatan Puskesmas
- Sistem Pencatatan Kesehatan Ibu dan Anak (KIA)

---

## Daftar Tabel Raw

### 1. raw_kunjungan
Data mentah kunjungan pasien ke fasilitas pelayanan kesehatan.

| Kolom | Tipe Data (Perkiraan) | Keterangan |
|------|----------------------|-----------|
| kunjungan_id | TEXT | ID kunjungan dari source |
| pasien_id | TEXT | ID pasien |
| tanggal_kunjungan | TEXT | Format asli dari sistem |
| jenis_kunjungan | TEXT | Umum / KIA / lainnya |
| fasilitas_id | TEXT | ID fasilitas |
| created_at | TEXT | Waktu pencatatan |

---

### 2. raw_anc
Data mentah pemeriksaan Antenatal Care (ANC).

| Kolom | Tipe Data (Perkiraan) | Keterangan |
|------|----------------------|-----------|
| anc_id | TEXT | ID pemeriksaan ANC |
| ibu_id | TEXT | ID ibu hamil |
| kunjungan_id | TEXT | Relasi ke kunjungan |
| usia_kehamilan | TEXT | Minggu kehamilan (as-is) |
| tekanan_darah | TEXT | Ditulis bebas |
| berat_badan | TEXT | Satuan belum distandarisasi |
| tanggal_pemeriksaan | TEXT | Format sumber |
| created_at | TEXT | Waktu input |

---

### 3. raw_ibu
Data induk ibu hamil.

| Kolom | Tipe Data | Keterangan |
|------|----------|-----------|
| ibu_id | TEXT | ID ibu |
| nama_ibu | TEXT | Nama lengkap |
| tanggal_lahir | TEXT | Format sumber |
| pendidikan | TEXT | As-is |
| pekerjaan | TEXT | As-is |
| alamat | TEXT | Bebas |

---

### 4. raw_fasilitas
Data fasilitas pelayanan kesehatan.

| Kolom | Tipe Data | Keterangan |
|------|----------|-----------|
| fasilitas_id | TEXT | ID fasilitas |
| nama_fasilitas | TEXT | Nama |
| jenis_fasilitas | TEXT | Puskesmas / Klinik |
| kecamatan | TEXT | Wilayah kerja |
| kabupaten | TEXT | As-is |

---

## Prinsip Desain Bronze
- Tidak ada validasi
- Tidak ada standardisasi
- Tidak ada foreign key
- Menyimpan data apa adanya (as-is)

# absensi_kegiatan

Multiplatform Apps for Absensi Kegiatan

## Getting Started

To Run or Build Project

flutter [build or run] web --web-renderer canvaskit --dart-define=BROWSER_IMAGE_DECODINDG_ENABLED=false
* canvaskit : diperlukan agar dapat menggunakan RepaintBoundary di web (capture widget to image)
* --dart-define=BROWSER_IMAGE_DECODINDG_ENABLED=false : diperlukan agar dapat mendownload widget image

## CHANGELOG

* 10-08-2023 -- Version 1.0.6+6
  * Upgrade Flutter To 3.10.6
* 10-08-2023 -- Version ...
  * Menambahkan fitur download pada halaman detail_agenda_view seperti pada halaman dashboard_view
  * Menebalkan garis tanda tangan, menjadi 7.5-8.5
  * Redesign dan memperbaiki halaman manage_instansi_view
  * Membuat fungsi download pdf, share dan print pada halaman detail peserta
  * Menambah ikon dan fungsi membuka halaman detail peserta melalui detail kegiatan

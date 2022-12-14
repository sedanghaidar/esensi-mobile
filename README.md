# absensi_kegiatan

Multiplatform Apps for Absensi Kegiatan

## Getting Started

To Run or Build Project

flutter [build or run] web --web-renderer canvaskit --dart-define=BROWSER_IMAGE_DECODINDG_ENABLED=false
* canvaskit : diperlukan agar dapat menggunakan RepaintBoundary di web (capture widget to image)
* --dart-define=BROWSER_IMAGE_DECODINDG_ENABLED=false : diperlukan agar dapat mendownload widget image

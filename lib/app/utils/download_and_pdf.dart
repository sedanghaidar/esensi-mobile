import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';
import 'package:absensi_kegiatan/app/data/model/NotulenModel.dart';
import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart' as pwx;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:google_fonts/google_fonts.dart' as gf;

import '../data/repository/ApiProvider.dart';
import 'date.dart';

const format = PdfPageFormat(
  8.5 * PdfPageFormat.inch,
  13 * PdfPageFormat.inch,
  // marginAll: 1 * PdfPageFormat.cm,
  marginLeft: 2.5 * PdfPageFormat.cm,
  marginRight: 2 * PdfPageFormat.cm,
  marginTop: 2 * PdfPageFormat.cm,
  marginBottom: 0 * PdfPageFormat.cm,
);

/// Fungsi untuk membuat tiket kegiatan menjadi file pdf
Future<Uint8List> createPdfTicket(PesertaModel? peserta) async {
  final logo = pw.MemoryImage(
      (await rootBundle.load("assets/logo_jateng2.png")).buffer.asUint8List());

  const format = PdfPageFormat(
    8.5 * PdfPageFormat.inch,
    13 * PdfPageFormat.inch,
    marginAll: 1 * PdfPageFormat.cm,
  );
  final pdf = pw.Document();
  pdf.addPage(pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Row(children: [
                pw.Image(logo, width: 48, height: 48),
                pw.Expanded(
                  flex: 1,
                  child: pw.Text("Pemerintah Provinsi Jawa Tengah",
                      style: pw.TextStyle(
                          fontSize: 24, fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center),
                ),
              ]),
              pw.Divider(),
              pw.Text("${peserta?.kegiatan?.name}",
                  style: pw.TextStyle(
                      color: PdfColor.fromHex("#b53471"),
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Column(children: [
                pw.Container(
                  child: pw.Text("Tanggal",
                      style: pw.TextStyle(color: PdfColor.fromHex("#b53471"))),
                ),
                pw.Text(dateToString(peserta?.kegiatan?.date)),
              ]),
              pw.SizedBox(height: 8),
              pw.Column(children: [
                pw.Container(
                  child: pw.Text("Waktu",
                      style: pw.TextStyle(color: PdfColor.fromHex("#b53471"))),
                ),
                pw.Text("${peserta?.kegiatan?.time} WIB"),
              ]),
              pw.SizedBox(height: 8),
              pw.Column(children: [
                pw.Container(
                  child: pw.Text("Tempat",
                      style: pw.TextStyle(color: PdfColor.fromHex("#b53471"))),
                ),
                pw.Text("${peserta?.kegiatan?.location}"),
              ]),
              pw.SizedBox(height: 16),
              pw.BarcodeWidget(
                  color: PdfColor.fromHex("#000000"),
                  barcode: pw.Barcode.qrCode(),
                  width: 200,
                  height: 200,
                  data: "${peserta?.qrCode}"),
              pw.SizedBox(height: 16),
              pw.Container(
                  padding: pw.EdgeInsets.all(4),
                  decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex("#b53471"),
                      borderRadius: pw.BorderRadius.circular(8)),
                  width: double.infinity,
                  child: pw.Column(children: [
                    pw.Text("${peserta?.name}",
                        style:
                            pw.TextStyle(color: PdfColor.fromHex("#ffffff"))),
                    pw.Text("${peserta?.jabatan}",
                        style:
                            pw.TextStyle(color: PdfColor.fromHex("#ffffff"))),
                    pw.Text("${peserta?.instansi}",
                        style:
                            pw.TextStyle(color: PdfColor.fromHex("#ffffff"))),
                  ]))
            ]);
      }));

  return await pdf.save();
}

Future<Uint8List> createPdfQrAbsen(
    KegiatanModel? kegiatan, String shortUrl) async {
  final logo = pw.MemoryImage(
      (await rootBundle.load("assets/logo_jateng2.png")).buffer.asUint8List());

  const format = PdfPageFormat(
    8.5 * PdfPageFormat.inch,
    13 * PdfPageFormat.inch,
    marginAll: 1 * PdfPageFormat.cm,
  );
  final pdf = pw.Document();
  pdf.addPage(pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Row(children: [
                pw.Image(logo, width: 48, height: 48),
                pw.Expanded(
                  flex: 1,
                  child: pw.Text("Pemerintah Provinsi Jawa Tengah",
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center),
                ),
              ]),
              pw.Divider(),
              pw.Text("${kegiatan?.name}",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      color: PdfColor.fromHex("#b53471"),
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.BarcodeWidget(
                  color: PdfColor.fromHex("#000000"),
                  barcode: pw.Barcode.qrCode(),
                  width: 180 * PdfPageFormat.mm,
                  height: 180 * PdfPageFormat.mm,
                  data: "${Uri.base.origin}/#/form/${kegiatan?.codeUrl}"),
              pw.SizedBox(height: 16),
              pw.Text(shortUrl,
                  textAlign: pw.TextAlign.center,
                  softWrap: true,
                  overflow: pw.TextOverflow.clip,
                  style: pw.TextStyle(
                      color: PdfColor.fromHex("#b53471"),
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold)),
            ]);
      }));

  return await pdf.save();
}

Future<Uint8List> createPdfNotulen(NotulenModel? notulen) async {
  final html = await pwx.HTMLToPdf().convert(notulen?.hasil ?? "");

  pw.ImageProvider img1;
  pw.ImageProvider img2;
  pw.ImageProvider img3;
  if (kReleaseMode) {
    img1 = await networkImage(
        '${ApiProvider.BASE_URL}/storage/images/${notulen?.image1}');
    img2 = await networkImage(
        '${ApiProvider.BASE_URL}/storage/images/${notulen?.image2}');
    img3 = await networkImage(
        '${ApiProvider.BASE_URL}/storage/images/${notulen?.image3}');
  } else {
    img1 = await networkImage(
        'https://images.unsplash.com/photo-1631947430066-48c30d57b943?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=716&q=80');
    img2 = await networkImage(
        'https://images.unsplash.com/photo-1520048330564-702a8875182f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1742&q=80');
    img3 = await networkImage(
        'https://images.unsplash.com/photo-1531291035213-47a9f036412c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1021&q=80');
  }

  String peserta = "";
  for (int i = 0; i < (notulen?.peserta?.length ?? 0); i++) {
    peserta += "${i + 1}.\t${notulen?.peserta?[i]}\n";
  }

  final doc = pw.Document();
  doc.addPage(pw.MultiPage(
      pageFormat: format,
      build: (context) {
        return [
          pw.Center(
            child: pw.Text(
              "NOTULEN RAPAT",
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Center(child: pw.Text("${notulen?.kegiatan?.name}")),
          pw.SizedBox(height: 24),
          pw.Row(children: [
            pw.Container(width: 70, child: pw.Text("Nomor")),
            pw.Text(" :  "),
            pw.Expanded(flex: 1, child: pw.Text("${notulen?.nosurat}"))
          ]),
          pw.SizedBox(height: 4),
          pw.Row(children: [
            pw.Container(width: 70, child: pw.Text("Tanggal")),
            pw.Text(" :  "),
            pw.Expanded(
                flex: 1,
                child: pw.Text(dateToString(notulen?.kegiatan?.date,
                    format: "EEEE, dd MMMM yyyy")))
          ]),
          pw.SizedBox(height: 4),
          pw.Row(children: [
            pw.Container(width: 70, child: pw.Text("Waktu")),
            pw.Text(" :  "),
            pw.Expanded(
                flex: 1, child: pw.Text("${notulen?.kegiatan?.time} WIB"))
          ]),
          pw.SizedBox(height: 4),
          pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Container(width: 70, child: pw.Text("Tempat")),
            pw.Text(" :  "),
            pw.Expanded(
                flex: 1, child: pw.Text("${notulen?.kegiatan?.location}"))
          ]),
          pw.SizedBox(height: 4),
          pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Container(width: 70, child: pw.Text("Peserta")),
            pw.Text(" :  "),
            pw.Expanded(
                flex: 1,
                child: pw.Text((notulen?.peserta?.length ?? 0) <= 3
                    ? peserta
                    : "Terlampir"))
          ]),
          pw.SizedBox(height: 24),
          pw.Text("HASIL", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Column(children: html),
          pw.SizedBox(height: 24),
          pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                  // alignment: pw.Alignment.center,
                  child: pw.Column(children: [
                pw.Text("${notulen?.jabatan}"),
                pw.SizedBox(height: 60),
                pw.Text("${notulen?.nama}",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text("${notulen?.pangkat}"),
                pw.SizedBox(height: 4),
                pw.Text("${notulen?.nip}"),
              ])))
        ];
      }));
  doc.addPage(pw.MultiPage(
      pageFormat: format,
      build: (context) {
        return [
          pw.Center(
              child: pw.Column(children: [
            pw.Text("DOKUMENTASI"),
            pw.SizedBox(height: 24),
            pw.Image(img1,
                width: format.width - 200, height: format.width - 200),
            pw.SizedBox(height: 16),
            notulen?.image2 == null
                ? pw.SizedBox()
                : pw.Image(img2,
                    width: format.width - 200, height: format.width - 200),
            pw.SizedBox(height: 16),
            notulen?.image3 == null
                ? pw.SizedBox()
                : pw.Image(img3,
                    width: format.width - 200, height: format.width - 200)
          ]))
        ];
      }));
  if ((notulen?.peserta?.length ?? 0) > 3) {
    doc.addPage(pw.MultiPage(
        pageFormat: format,
        build: (context) {
          return [
            pw.Center(
              child: pw.Text("PESERTA"),
            ),
            pw.SizedBox(height: 24),
            pw.Text(peserta)
          ];
        }));
  }
  return doc.save();
}

downloadPdf(String filename, Uint8List file) {
  if (kIsWeb) {
    FileSaver.instance
        .saveFile(name: filename, mimeType: MimeType.pdf, bytes: file);
  } else {
    FileSaver.instance.saveAs(
        name: filename, ext: ".pdf", mimeType: MimeType.pdf, bytes: file);
  }
}

sharePdf(String filename, Uint8List file) async {
  await Printing.sharePdf(bytes: file, filename: "$filename.pdf");
}

printPdf(Uint8List file) async {
  await Printing.layoutPdf(onLayout: (PdfPageFormat format) {
    return file;
  });
}

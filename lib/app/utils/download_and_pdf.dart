import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'date.dart';

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

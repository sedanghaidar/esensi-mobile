import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';

KegiatanModel kegiatanModel1 = KegiatanModel(
    name: "FGD",
    date: DateTime(2022, 12, 15),
    time: "09:00",
    location: "Kantor Kominfo",
    dateEnd: DateTime(2022, 12, 14),
    isLimitParticipant: true);

KegiatanModel kegiatanModel2 = KegiatanModel(
    name: "FGD",
    date: DateTime(2022, 12, 15),
    time: "09:00",
    location: "Kantor Kominfo",
    dateEnd: null,
    isLimitParticipant: false);

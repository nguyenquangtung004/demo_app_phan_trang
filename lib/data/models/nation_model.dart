import '../../domain/entities/nation.dart';

class NationModel {
  final String commonName;
  final String officialName;
  final String flagUrl;

  const NationModel({
    required this.commonName,
    required this.officialName,
    required this.flagUrl,
  });

  factory NationModel.fromJson(Map<String, dynamic> json) {
  try {
    return NationModel(
      commonName: json['name']?['common'] ?? 'Unknown Name',
      officialName: json['name']?['official'] ?? 'Unknown Official Name',
      flagUrl: json['flags']?['png'] ?? 'https://via.placeholder.com/150',
      // commonName: json['country_name'] ?? 'Unknown',
      // officialName: json['official_title'] ?? 'Unknown',
      // flagUrl: json['flag_image'] ?? 'https://placeholder.com/150',
    );
  } catch (e) {
    print('❌ [NationModel] Lỗi khi parse JSON: $e');
    throw Exception('Lỗi khi parse JSON: $e');
  }
}

  //IMPORTANT : Việc chuyển đổi dữ liệu từ model sang entity 
  //NOTE : Thứ nhất không phụ thuộc vào nguồn dữ liệu lấy từ api
  //NOTE : Dưới là api
  //ERROR :  "country_name": "Vietnam",
  //ERROR : "official_title": "Socialist Republic of Vietnam",
  //ERROR : "flag_image": "https://flagcdn.com/vn.png"
  //NOTE : Ta chỉ cần thay đổi trên nation model còn  nation entity giữ nguyên
  // ----
  //NOTE : Thứ hai lấy những dữ liệu không cần thiết
  //NOTE : Dưới là api 
  //   {
  //    "name": {
  //       "common": "Vietnam",
  //       "official": "Socialist Republic of Vietnam"
  //    },
  //    "flags": {
  //       "png": "https://flagcdn.com/vn.png"
  //    },
  //    "population": 98000000
  // }
  //NOTE : Còn bên entity 
  // class NationEntity {
  //   final String commonName;
  //   final String officialName;
  //   final String flagUrl;
  // }
  NationEntity toEntity() {
    return NationEntity(
      commonName: commonName,
      officialName: officialName,
      flagUrl: flagUrl,
    );
  }
}

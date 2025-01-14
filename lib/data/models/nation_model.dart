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
    );
  } catch (e) {
    print('❌ [NationModel] Lỗi khi parse JSON: $e');
    throw Exception('Lỗi khi parse JSON: $e');
  }
}


  NationEntity toEntity() {
    return NationEntity(
      commonName: commonName,
      officialName: officialName,
      flagUrl: flagUrl,
    );
  }
}

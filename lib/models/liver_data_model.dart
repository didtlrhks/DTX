class LiverData {
  final String patientName;
  final String patientId;
  final Indices indices;
  final ReferenceValues referenceValues;

  LiverData({
    required this.patientName,
    required this.patientId,
    required this.indices,
    required this.referenceValues,
  });

  factory LiverData.fromJson(Map<String, dynamic> json) {
    return LiverData(
      patientName: json['patient_name'],
      patientId: json['patient_id'],
      indices: Indices.fromJson(json['indices']),
      referenceValues: ReferenceValues.fromJson(json['reference_values']),
    );
  }
}

class Indices {
  final IndexData fli;
  final IndexData hsi;

  Indices({
    required this.fli,
    required this.hsi,
  });

  factory Indices.fromJson(Map<String, dynamic> json) {
    return Indices(
      fli: IndexData.fromJson(json['fli']),
      hsi: IndexData.fromJson(json['hsi']),
    );
  }
}

class IndexData {
  final double value;
  final String interpretation;

  IndexData({
    required this.value,
    required this.interpretation,
  });

  factory IndexData.fromJson(Map<String, dynamic> json) {
    return IndexData(
      value: json['value'].toDouble(),
      interpretation: json['interpretation'],
    );
  }
}

class ReferenceValues {
  final double triglyceride;
  final double bmi;
  final double ggt;
  final double waistCircumference;
  final double alt;
  final double ast;
  final bool hasDiabetes;

  ReferenceValues({
    required this.triglyceride,
    required this.bmi,
    required this.ggt,
    required this.waistCircumference,
    required this.alt,
    required this.ast,
    required this.hasDiabetes,
  });

  factory ReferenceValues.fromJson(Map<String, dynamic> json) {
    return ReferenceValues(
      triglyceride: json['triglyceride'].toDouble(),
      bmi: json['bmi'].toDouble(),
      ggt: json['ggt'].toDouble(),
      waistCircumference: json['waist_circumference'].toDouble(),
      alt: json['alt'].toDouble(),
      ast: json['ast'].toDouble(),
      hasDiabetes: json['has_diabetes'],
    );
  }
}

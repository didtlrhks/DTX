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
  final IndexData fibrosis;

  Indices({
    required this.fli,
    required this.fibrosis,
  });

  factory Indices.fromJson(Map<String, dynamic> json) {
    return Indices(
      fli: IndexData.fromJson(json['fli']),
      fibrosis: IndexData.fromJson(json['fibrosis']),
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
  final int age;
  final double ast;
  final double alt;
  final int plt;
  final double bmi;
  final double albumin;
  final bool hasDiabetes;

  ReferenceValues({
    required this.age,
    required this.ast,
    required this.alt,
    required this.plt,
    required this.bmi,
    required this.albumin,
    required this.hasDiabetes,
  });

  factory ReferenceValues.fromJson(Map<String, dynamic> json) {
    return ReferenceValues(
      age: json['age'],
      ast: json['ast'].toDouble(),
      alt: json['alt'].toDouble(),
      plt: json['plt'],
      bmi: json['bmi'].toDouble(),
      albumin: json['albumin'].toDouble(),
      hasDiabetes: json['has_diabetes'],
    );
  }
}

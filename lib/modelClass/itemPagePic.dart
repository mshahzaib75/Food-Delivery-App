// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// ignore: file_names
class Picture {
  String image;
  Picture({
    required this.image,
  });

  Picture copyWith({
    String? image,
  }) {
    return Picture(
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
    };
  }

  factory Picture.fromMap(Map<String, dynamic> map) {
    return Picture(
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Picture.fromJson(String source) => Picture.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Picture(image: $image)';

  @override
  bool operator ==(covariant Picture other) {
    if (identical(this, other)) return true;
  
    return 
      other.image == image;
  }

  @override
  int get hashCode => image.hashCode;
}

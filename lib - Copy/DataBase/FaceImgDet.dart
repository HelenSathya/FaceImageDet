class FaceImgDet {
  late final String faceId;
  late final String name;
  late final String base64Str;
 
  FaceImgDet({
    required this.faceId,
    required this.name,
    required this.base64Str,
  });
  
  FaceImgDet.fromMap(Map<String, dynamic> result)
      : faceId = result["faceId"],
        name = result["name"],
        base64Str = result["base64Str"];
  Map<String, Object> toMap() {
    return {
      'faceId': faceId,
      'name': name,
      'base64Str': base64Str,
    };
  }
}
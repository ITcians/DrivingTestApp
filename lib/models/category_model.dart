class CategoryModel {
  dynamic version, category, image,id;

  CategoryModel({this.category, this.image, this.version});

  factory CategoryModel.fromJson(map) => CategoryModel(
      category: map['category'], version: map['version'], image: map['image']);

  Map<String, dynamic> toJson() =>
      {'category': category, 'version': version, 'image': image};
}

import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// Gambar milik sebuah project (read-only dari server).
@JsonSerializable()
class ProjectImage {
  final String url;
  final int order;

  const ProjectImage({required this.url, required this.order});

  factory ProjectImage.fromJson(Map<String, dynamic> json) =>
      _$ProjectImageFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectImageToJson(this);
}

/// Project dari backend Django (`/api/v1/projects/`).
/// Field bertanda `includeToJson: false` hanya dibaca dari server, tidak dikirim.
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  @JsonKey(includeToJson: false)
  final String? id;
  final String title;
  @JsonKey(defaultValue: '')
  final String description;
  final String category;
  @JsonKey(includeToJson: false)
  final String? categoryDisplay;

  /// Dibaca sebagai "November 2026", dikirim sebagai `yyyy-MM-dd`.
  final String startedAt;
  final String? endedAt;
  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isOngoing;
  @JsonKey(includeToJson: false, defaultValue: <ProjectImage>[])
  final List<ProjectImage> images;

  const Project({
    this.id,
    required this.title,
    this.description = '',
    required this.category,
    this.categoryDisplay,
    required this.startedAt,
    this.endedAt,
    this.isOngoing = false,
    this.images = const [],
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  String get categoryLabel => categoryDisplay ?? category;

  String get period =>
      '$startedAt - ${isOngoing ? 'Ongoing' : (endedAt ?? '-')}';
}

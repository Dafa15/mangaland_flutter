class Tag {
  String id;
  String? group;
  String? name;
  int? version;

  Tag({
    required this.id,
    required this.group,
    required this.name,
    required this.version,
  });

  @override
  String toString() {
    return 'Tag{id: $id, group: $group, name: $name, version: $version}';
  }
}

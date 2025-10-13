class UserModel {
  final String id;
  final String email;
  final String? name;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
    id: json['id'] as String, 
    email: json['email'] as String, 
    name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id' : id,
      'email' : email,
      'name' : name,
    };
  }
}
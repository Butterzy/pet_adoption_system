class thisPost {
  final String? postid;

  thisPost({this.postid});
}

thisPost? _postFromFirebaseUser(PostData? post) {
  return post != null ? thisPost(postid: post.post_ID) : null;
}

class PostData {
  String? post_ID;
  String? post_name;
  String? post_desc;
  String? post_location;
  String? post_start;
  String? post_end;
  String? post_contact;
  String? post_age;
  String? post_color;
  String? post_type;
  String? post_gender;
  String? post_vaccinated;
  String? post_dewormed;
  String? post_spayed;
  String? post_health;
  String? myrole;
  int? post_numAdoption;
  String? post_image;
  String? pet_ID;
  String? pet_owner;
  String? post_date;

  PostData(
      {this.post_ID,
      this.post_name,
      this.post_desc,
      this.post_location,
      this.post_start,
      this.post_end,
      this.post_contact,
      this.post_age,
      this.post_color,
      this.post_type,
      this.post_gender,
      this.post_vaccinated,
      this.post_dewormed,
      this.post_spayed,
      this.post_health,
      this.myrole,
      this.post_numAdoption,
      this.post_image,
      this.pet_ID,
      this.pet_owner,
      this.post_date});
}

class RegisterData {
  String? register_ID;
  String? post_ID;
  String? pet_category;
  String? user_ID;
  String? app_fname;
  String? app_lname;
  String? app_cfname;
  String? app_clname;
  String? app_email;
  String? app_HPno;
  String? app_gender;
  String? app_gender1;
  String? app_occupation;
  String? app_occupation1;
  String? app_addStreet1;
  String? app_addStreet2;
  String? app_addPostcode;
  String? app_addCity;
  String? app_addState;
  String? app_q1;
  String? app_q2;
  String? app_q3;
  String? app_q4;
  String? app_q5;
  String? app_q6;
  String? app_q7;
  String? app_q8;
  String? app_q9;
  String? app_status;
  String? app_time;
  String? postowner_contact;

  RegisterData(
      {this.register_ID,
      this.post_ID,
      this.pet_category,
      //  this.post_contact,
      this.user_ID,
      this.app_fname,
      this.app_lname,
      this.app_cfname,
      this.app_clname,
      this.app_email,
      this.app_HPno,
      this.app_gender,
      this.app_gender1,
      this.app_occupation,
      this.app_occupation1,
      this.app_addStreet1,
      this.app_addStreet2,
      this.app_addPostcode,
      this.app_addCity,
      this.app_addState,
      this.app_q1,
      this.app_q2,
      this.app_q3,
      this.app_q4,
      this.app_q5,
      this.app_q6,
      this.app_q7,
      this.app_q8,
      this.app_q9,
      this.app_status,
      this.app_time,
      this.postowner_contact});
}

class CompleteAdoption {
  String? pet_category;
  String? register_id;

  CompleteAdoption({this.pet_category, this.register_id});
}

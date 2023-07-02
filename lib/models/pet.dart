class thisPet {
  final String? uid;

  thisPet({this.uid});
}

class PetData {
  String? pet_ID;
  String? pet_name;
  String? pet_category;
  String? pet_desc;
  String? pet_image;
  String? pet_age;
  String? pet_type;
  String? pet_color;
  String? pet_gender;
  String? pet_vaccinated;
  String? pet_dewormed;
  String? pet_health;
  String? pet_spayed;
  String? pet_registerDate;
  String? pet_owner;
  String? my_role;

  PetData({
    this.pet_ID,
    this.pet_name,
    this.pet_category,
    this.pet_desc,
    this.pet_image,
    this.pet_age,
    this.pet_type,
    this.pet_color,
    this.pet_gender,
    this.pet_vaccinated,
    this.pet_dewormed,
    this.pet_health,
    this.pet_spayed,
    this.pet_registerDate,
    this.pet_owner,
    this.my_role,
  });

  get creatorID => null;
}

class CommitteeData {
  String? committee_ID;
  String? pet_ID;
  String? user_ID;
  bool? isApproved;
  String? approved_by;
  String? approved_date;
  String? application_ID;

  CommitteeData(
      {this.committee_ID,
      this.pet_ID,
      this.user_ID,
      this.isApproved,
      this.approved_by,
      this.approved_date,
      this.application_ID});
}

class ApplicationData {
  String? application_ID;
  String? application_name;
  String? seq_number;
  String? pet_ID;

  ApplicationData({
    this.application_ID,
    this.application_name,
    this.seq_number,
    this.pet_ID,
  });
}

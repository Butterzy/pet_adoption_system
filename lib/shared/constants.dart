import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Container loadingIndicator() {
  return Container(
    color: Colors.white,
    child: const Center(
      child: SpinKitHourGlass(
        color: Colors.indigo,
        size: 30.0,
      ),
    ),
  );
}

AppBar buildAppBar(BuildContext context, String title) {
  return AppBar(
    centerTitle: true,
    title: Text(title,
        style: const TextStyle(
            color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 20.0)),
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.arrow_back, color: Colors.indigo),
    ),
  );
}

showNormalSnackBar(String snacktext, BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  final snackBar = SnackBar(
    content: Row(
      children: [
        const Icon(Icons.info_outline, color: Colors.white, size: 20.0),
        const SizedBox(width: 10.0),
        Flexible(
            child: Text(snacktext,
                style: const TextStyle(fontSize: 18.0, color: Colors.white)))
      ],
    ),
    duration: const Duration(seconds: 5),
    backgroundColor: Colors.indigo,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

showSuccessSnackBar(String snacktext, BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  final snackBar = SnackBar(
    content: Row(
      children: [
        const Icon(Icons.info_outline, color: Colors.white, size: 20.0),
        const SizedBox(width: 10.0),
        Flexible(
            child: Text(snacktext,
                style: const TextStyle(fontSize: 18.0, color: Colors.white)))
      ],
    ),
    duration: const Duration(seconds: 5),
    backgroundColor: Colors.green,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

showFailedSnackBar(String snacktext, BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  final snackBar = SnackBar(
    content: Row(
      children: [
        const Icon(Icons.info_outline, color: Colors.white, size: 20.0),
        const SizedBox(width: 10.0),
        Flexible(
            child: Text(snacktext,
                style: const TextStyle(fontSize: 18.0, color: Colors.white)))
      ],
    ),
    duration: const Duration(seconds: 5),
    backgroundColor: Colors.red,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

var textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
);

String? emailValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter the email';
  }
  //reg expression for email validation
  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
    return 'Please Enter a valid email';
  }
  return null;
}

String? passwordValidator(value) {
  RegExp regex = RegExp(r'^.{6,}$');
  if (value!.isEmpty) {
    return 'Password is required';
  }
  if (!regex.hasMatch(value)) {
    return 'Please enter valid password (Min. 6 character)';
  }
  return null;
}

String? firstNameValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter your first name';
  }
  if (value!.length < 2) {
    return 'First name is required at least 2 characters';
  }
  return null;
}

String? lastNameValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter your last name';
  }
  if (value!.length < 2) {
    return 'last name is required at least 2 characters';
  }
  return null;
}

String? phoneNoValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter your phone number';
  }
  if (value!.length == 11 || value!.length == 12) {
    return null;
  } else {
    return 'Please enter a valid phone number !';
  }
}

String? streetValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter your street address';
  }
  return null;
}

String? cityValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter your city';
  }
  return null;
}

String? postcodeValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter your postcode';
  }
  if (value!.length == 5) {
    return null;
  } else {
    return 'Please enter a valid postcode';
  }
}

String? petNameValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter the pet name';
  }
  if (value!.length < 1) {
    return 'pet name is required at least 3 characters';
  }
  return null;
}

String? petDescValidator(value) {
  if (value!.isEmpty) {
    return 'Please tell something about the pet';
  }
  return null;
}

String? petColorValidator(value) {
  if (value!.isEmpty) {
    return 'Please tell the color of pet';
  }
  return null;
}

String? petCategoryValidator(value) {
  if (value!.isEmpty) {
    return 'Please tell the type of pet';
  }
  return null;
}

String? petGenderValidator(value) {
  if (value!.isEmpty) {
    return 'Please tell the gender of pet';
  }
  return null;
}

String? vaccinatedValidator(value) {
  if (value!.isEmpty) {
    return 'Please tell the vaccination status of pet';
  }
  return null;
}

String? dewormedValidator(value) {
  if (value!.isEmpty) {
    return 'Please tell the deworming status of pet';
  }
  return null;
}

String? spayedValidator(value) {
  if (value!.isEmpty) {
    return 'Please tell the neuter status of pet';
  }
  return null;
}

String? healthValidator(value) {
  if (value!.isEmpty) {
    return 'Please tell the health status of pet';
  }
  return null;
}

String? roleValidator(value) {
  if (value!.isEmpty) {
    return 'Please tell your role';
  }
  return null;
}

String? petAgeValidator(value) {
  if (value!.isEmpty) {
    return 'Please tell pet age';
  }
  return null;
}

String? questionValidator(value) {
  if (value.isEmpty) {
    return 'This field can\'t leave empty !';
  } else  {
    return null;
  } 
}

String? occupationValidator(value) {
  if (value!.isEmpty) {
    return 'Please tell your occupation';
  }
  return null;
}

String? postNameValidator(value) {
  if (value.isEmpty) {
    return 'The pet name is required !';
  } else {
    return null;
  }
}

String? captionValidator(value) {
  if (value.isEmpty) {
    return 'The caption is required !';
  }  else {
    return null;
  }
}

String? titleValidator(value) {
  if (value.isEmpty) {
    return 'The article title is required !';
  } else {
    return null;
  }
}

String? contentValidator(value) {
  if (value.isEmpty) {
    return 'The article content is required !';
  } else {
    return null;
  }
}

String? locationValidator(value) {
  if (value.isEmpty) {
    return 'The location is required !';
  } else {
    return null;
  }
}

DecoratedBox buildGradientLine(Color leftColor, Color rightColor) {
  return DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [leftColor, rightColor]),
    ),
    child: Container(
      margin: const EdgeInsets.all(1),
    ),
  );
}

final List<String> petCategory = [
  'Cat',
  'Dog',
  'Hamster',
  'Rabbit',
  'Tortoise',
  'Bird',
  'Others'
];

final List<String> audienceList = ['Public', 'Private'];

final List<String> genderGroup = ['Male', 'Female'];

final List<String> peopleGroup = ['0','1', '2', '3','4','5','More than 5'];

final List<String> optionList = ['Yes', 'No', 'Not Sure'];

final List<String> healthdGroup = ['Healthy', 'Minor Injury', 'Serious Injury'];

final List<String> roleGroup = ['Rescuer', 'Fosterer', 'Owner', 'Pet Merchant'];

final List<String> statusGroup = [
  'Pending',
  'Approved',
  'Rejected',
  'Require Meeting with Pet',
  'Under Review',
  'Finalize paper-work',
  'Request Cancel',
  'Cancelled'
];

final List<String> stateGroup = [
  'Johor',
  'Kedah',
  'Kelantan',
  'Malacca',
  'Negeri Sembilan',
  'Pahang',
  'Penang',
  'Perak',
  'Perlis',
  'Sabah',
  'Sarawak',
  'Selangor',
  'Terengganu',
  'Kuala Lumpur',
  'Labuan',
  'Putrajaya'
];

var user_name = "";

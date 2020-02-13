class Validator {
  static String validateEmail(String value) {
    Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = new RegExp(pattern);
    if(value.trim().isEmpty){
      return "Entrez votre mail";
    }
    if (!regex.hasMatch(value))
      return "S'il vous plait entrez un mail valide";
    else
      return null;

  }

  static String validatePassword(String value) {
    Pattern pattern = r'^.{6,}$';
    RegExp regex = new RegExp(pattern);
    if(value.trim().isEmpty){
      return "Entrez votre mot de passe s'il vous plait";
    }
    if (!regex.hasMatch(value))
      return 'Le mot de passe doit etre au moins de 8 characteres';
    else
      return null;
  }

  static String validateName(String value) {
    Pattern pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
    RegExp regex = new RegExp(pattern);
    if(value.trim().isEmpty){
      return "Entrez votre nom s'il vous plait";
    }
    if (!regex.hasMatch(value))
      return 'Entrez un nom valide.';
    else
      return null;
  }

  static String validateLastName(String value) {
    Pattern pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
    RegExp regex = new RegExp(pattern);
    if(value.trim().isEmpty){
      return "Entrez votre prenom s'il vous plait";
    }
    if (!regex.hasMatch(value))
      return 'Entrez un nom valide.';
    else
      return null;
  }

  static String validateNumber(String value) {
    Pattern pattern = r'^\D?(\d{3})\D?\D?(\d{3})\D?(\d{4})$';
    RegExp regex = new RegExp(pattern);
    if(value.trim().isEmpty){
      return "Entrez votre numero ";
    }
    if (!regex.hasMatch(value))
      return 'entrez un numero valide .';
    else
      return null;
  }

}
class Customer {
  // int NewID;
  String name;
  String city;
  int ph;
  int? NewID;

  Customer({
    // required this.NewID,
    required this.name,
    required this.city,
    required this.ph,
    this.NewID,
  });

  // Convert JSON to a Customer object
  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        name: json["Name"],
        city: json["City"],
        ph: json["ph"],
        NewID: json["Id"],
      );

  // Convert a Customer object to JSON
  Map<String, dynamic> toJson() => {
        "Name": name,
        "City": city,
        "ph": ph,
        "NEWId": NewID,
      };
}

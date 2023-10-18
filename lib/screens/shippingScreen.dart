import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divine/backgroundDesign/bg.dart';
import 'package:divine/screens/placeOrderScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../colors.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({
    super.key,
    required this.totalCartPrice,
  });
  final num totalCartPrice;

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  TextEditingController locationController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formField = GlobalKey<FormState>();
  Map<String, dynamic> userData = {};

  Future<DocumentSnapshot<Map<String, dynamic>>> getData() async {
    return await FirebaseFirestore.instance
        .collection('SignUpUsers')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();
  }

  RegExp name_valid =
      RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
  bool validateName(String name) {
    String _name = name.toUpperCase();
    if (name_valid.hasMatch(_name)) {
      return true;
    } else {
      return false;
    }
  }

  void storeOrderDetails() async {
    String? userEmail = FirebaseAuth.instance.currentUser!.email;
    String userName = userNameController.text.toString();
    String userPhone = phoneController.text;
    String userAddress = addressController.text;
    String selectedCity = SelectedCity;
    String userLocation = currentAddress;
    await FirebaseFirestore.instance
        .collection('ShippingAddress')
        .doc(userEmail)
        .set({
      'userEmail': userEmail,
      'userName': userName,
      'userPhone': userPhone,
      'userAddress': userAddress,
      'selectedCity': selectedCity,
      'userLocation': userLocation,
    });
  }

  Future<void> loadUserData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await getData();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()!;
      setState(() {
        userNameController.text = data['displayName'] ?? '';
        phoneController.text = data['phone'] ?? '';
        userData = snapshot.data()!;
      });
    }
  }

  //To Fetch The User Current Location
  bool isLocationFetched = false;
  String currentAddress = '';
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: boxColor,
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: boxColor,
            content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: boxColor,
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng(_currentPosition!);
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        isLocationFetched = true;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  List<String> cities = [
    "Karachi",
    "Lahore",
    "Islamabad",
    "Faisalabad",
    "Rawalpindi",
    "Multan",
    "Peshawar",
    "Quetta",
    "Gujranwala",
    "Sialkot",
    "Hyderabad",
    "Abbottabad",
    "Bahawalpur",
    "Sargodha",
    "Sukkur",
    "Larkana",
    "Rahim Yar Khan",
    "Gwadar",
    "Murree",
    "Muzaffarabad",
  ];
  String SelectedCity = '';
  @override
  void dispose() {
    addressController.dispose();
    userNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            const BackGroundDesign(),
            SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      height: height * 0.06,
                      width: width,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(7, 7, 10, 0),
                            child: IconButton(
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  await Future.delayed(
                                      const Duration(milliseconds: 100));
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 27,
                                  color: yellow,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(6, 12, 0, 0),
                            child: Row(
                              children: [
                                const Text('PKR',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: whiteColor,
                                        fontWeight: FontWeight.w600)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                      '${widget.totalCartPrice}'.toString(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: whiteColor,
                                          fontWeight: FontWeight.w900)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 22),
                    child: SizedBox(
                        height: height * 0.08,
                        width: width * 0.9,
                        child: container(height, width, context, 'Email')),
                  ),
                  SizedBox(
                      height: height * 0.06,
                      width: width * 0.9,
                      child: const Center(
                        child: FittedBox(
                          child: Text(
                            'Shipping Address',
                            style: TextStyle(
                                fontSize: 20,
                                color: yellow,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      )),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    height: height * 0.65,
                    width: width * 0.9,
                    child: Container(
                      color: boxColor,
                      child: Form(
                        key: formField,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            userNameUpdateField(
                                height * 0.08,
                                width * 0.9,
                                userData['displayName'].toString(),
                                userNameController),
                            phoneUpdateField(height * 0.08, width * 0.9,
                                userData['phone'].toString(), phoneController),
                            addressField(
                                height * 0.08, width * 0.9, addressController),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: TextFormField(
                                readOnly: true,
                                style: const TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                textAlign: TextAlign.start,
                                controller:
                                    TextEditingController(text: SelectedCity),
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          showCityPicker(context, height * 0.02,
                                              width * 0.08);
                                        },
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: yellow,
                                          size: 30,
                                        )),
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    border: const UnderlineInputBorder(),
                                    hintStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900),
                                    labelText: 'Select City',
                                    labelStyle: const TextStyle(
                                      color: yellow,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a city';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: TextFormField(
                                readOnly: true,
                                style: const TextStyle(color: Colors.white),
                                cursorColor: whiteColor,
                                textAlign: TextAlign.start,
                                onTap: () {
                                  _getCurrentPosition();
                                },
                                decoration: InputDecoration(
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    border: const UnderlineInputBorder(),
                                    hintStyle: TextStyle(
                                        color: isLocationFetched
                                            ? Colors.white
                                            : yellow,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    hintText: isLocationFetched
                                        ? currentAddress
                                        : "Share Location",
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white))),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            SizedBox(
                              height: height * 0.065,
                              child: InkWell(
                                onTap: () {
                                  if (formField.currentState!.validate()) {
                                    storeOrderDetails();
                                    PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: PlaceOrderScreen(
                                          firstTotalCartPrice:
                                              widget.totalCartPrice,
                                        ),
                                        withNavBar: false);
                                  }
                                },
                                child: Container(
                                  height: height * 0.08,
                                  width: width * 0.85,
                                  decoration: BoxDecoration(
                                      color: yellow,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: const Center(
                                    child: FittedBox(
                                      child: Text(
                                        'Continue to Payment',
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  Widget userNameUpdateField(
    double height,
    double width,
    String value,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        cursorColor: whiteColor,
        textAlign: TextAlign.start,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            border: const UnderlineInputBorder(),
            labelText: 'Username',
            labelStyle: const TextStyle(
              color: yellow,
              fontWeight: FontWeight.w900,
            ),
            hintStyle: const TextStyle(color: Colors.white),
            hintText: value,
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white))),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter a name';
          } else {
            bool result = validateName(value);
            if (result) {
              return null;
            } else {
              return "Format 'Full Name'";
            }
          }
        },
      ),
    );
  }

  void showCityPicker(BuildContext context, double height, double width) {
    showModalBottomSheet(
      backgroundColor: whiteColor,
      context: context,
      builder: (BuildContext builder) {
        return ListView.builder(
          itemCount: cities.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                cities[index],
                style:
                    const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
              ),
              onTap: () {
                setState(() {
                  SelectedCity = cities[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  Widget addressField(
    double height,
    double width,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        cursorColor: whiteColor,
        textAlign: TextAlign.start,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: addressController,
        decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            border: UnderlineInputBorder(),
            labelText: 'Address',
            labelStyle: TextStyle(
              color: yellow,
              fontWeight: FontWeight.w900,
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white))),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Address cannot be empty';
          } else {
            return null;
          }
        },
      ),
    );
  }
}

Widget phoneUpdateField(
  double height,
  double width,
  String value,
  TextEditingController controller,
) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    child: TextFormField(
      style: const TextStyle(color: Colors.white),
      cursorColor: whiteColor,
      textAlign: TextAlign.start,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          border: const UnderlineInputBorder(),
          labelText: 'Phone',
          labelStyle: const TextStyle(
            color: yellow,
            fontWeight: FontWeight.w900,
          ),
          hintStyle: const TextStyle(color: Colors.white),
          hintText: value,
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white))),
      validator: (value) {
        bool phoneValid =
            RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value!);
        if (value.isEmpty) {
          return 'Enter phone number';
        } else if (!phoneValid && controller.text.length != 11) {
          return 'Enter valid phone number';
        }
        return null;
      },
      keyboardType: TextInputType.phone,
    ),
  );
}

Widget container(
    double height, double width, BuildContext context, String text1) {
  String? email = FirebaseAuth.instance.currentUser!.email;
  return SizedBox(
    height: height,
    width: width,
    child: Container(
      color: boxColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text1,
                style: const TextStyle(
                  fontSize: 14,
                  color: yellow,
                  fontWeight: FontWeight.w900,
                )),
            SizedBox(height: height * 0.005),
            Text(
              '$email',
              style: const TextStyle(fontSize: 17, color: whiteColor),
            )
          ],
        ),
      ),
    ),
  );
}

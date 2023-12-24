import 'package:coffee/common/widgets/custom_button.dart';
import 'package:coffee/common/widgets/custom_textfield.dart';
import 'package:coffee/constants/global_variables.dart';
import 'package:coffee/constants/utils.dart';
import 'package:coffee/features/address/services/address_services.dart';
// import 'package:coffee/constants/utils.dart';
import 'package:coffee/providers/user_provider.dart';
import 'package:flutter/material.dart';
// import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController _flatBuildingController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();

  String addressToBeUsed = "";
  // List<PaymentItem> paymentItems = [];
  final AddressServices addressServices = AddressServices();

  // @override
  // void initState() {
  //   paymentItems.add(
  //     PaymentItem(
  //         amount: widget.totalAmount,
  //         label: 'Total Amount',
  //         status: PaymentItemStatus.final_price),
  //   );
  //   super.initState();
  // }//!since pay isnt working paymentItems is not required

  @override
  void dispose() {
    super.dispose();
    _flatBuildingController.dispose();
    _areaController.dispose();
    _zipCodeController.dispose();
    _cityController.dispose();
  }

  // void onGooglePayResult(res) {
  //   if (Provider.of<UserProvider>(context).user.address.isEmpty) {

  //   }
  // }//!google pay stuff isnt working

  void payPressed(String addressFromProvider) {
    addressToBeUsed = "";

    bool isForm = _flatBuildingController.text.isNotEmpty ||
        _areaController.text.isNotEmpty ||
        _zipCodeController.text.isNotEmpty ||
        _cityController.text.isNotEmpty;
    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            "${_flatBuildingController.text}, ${_areaController.text}, ${_cityController.text}, ZIP: ${_zipCodeController.text}";
      } else {
        throw Exception('Please Enter All the Values');
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context, 'ERROR');
    }
    addressServices.saveUserAddress(
      context: context,
      address: addressToBeUsed,
    );
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    if (address.isNotEmpty)
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                address,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    CustomTextField(
                      controller: _flatBuildingController,
                      hintText: 'Flat, House no., Building',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: _areaController,
                      hintText: 'Area, Street',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: _zipCodeController,
                      hintText: 'ZIP code',
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: _cityController,
                      hintText: 'Town/City',
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              CustomButton(text: 'Pay Now!', onTap: () => payPressed(address)),

              // GooglePayButton(
              //   onPressed: () => payPressed(address),
              //   onPaymentResult: onGooglePayResult,
              //   paymentItems: paymentItems,
              //   height: 50,
              //   type: GooglePayButtonType.pay,
              //   margin: const EdgeInsets.only(
              //     top: 15,
              //   ),
              //   loadingIndicator: const Center(
              //     child: CircularProgressIndicator(),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

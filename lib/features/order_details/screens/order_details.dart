import 'package:coffee/common/widgets/custom_button.dart';
import 'package:coffee/constants/global_variables.dart';
import 'package:coffee/features/admin/services/admin_services.dart';
import 'package:coffee/features/search/screen/search_screen.dart';
import 'package:coffee/models/order.dart';
import 'package:coffee/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  static const routeName = "/order-details";
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final AdminServices adminServices = AdminServices();
  int currentStep = 0;
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(
      context,
      SearchScreen.routeName,
      arguments: query,
    );
  }
  //only for admin
  void changeOrderStatus (int status) {
    adminServices.changeOrderStatus(context: context, status: status+1, order: widget.order, onSuccess: () {
      setState(() {
        currentStep += 1;
      });
    });
  }

  @override
  void initState() { 
    super.initState();
    currentStep = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
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
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Container(
                height: 42,
                margin: const EdgeInsets.only(left: 15),
                child: Material(
                  borderRadius: BorderRadius.circular(7),
                  elevation: 1,
                  child: TextFormField(
                    onFieldSubmitted: navigateToSearchScreen,
                    decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.search,
                              color: Colors.black12,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide:
                              BorderSide(color: Colors.black38, width: 1),
                        ),
                        hintText: 'Search for Items',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        )),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              height: 42,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: const Icon(
                Icons.mic,
                color: Colors.black,
                size: 25,
              ),
            )
          ]),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "View Order Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order date:                ${DateFormat().format(DateTime.fromMillisecondsSinceEpoch(widget.order.orderedAt))}",
                    ),
                    Text(
                      "Order ID:                    ${widget.order.id}",
                    ),
                    Text(
                      "Order Total:               \$${widget.order.totalPrice.toStringAsFixed(2)}",
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Purchase Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (int i = 0; i < widget.order.items.length; i++)
                    Row(
                      children: [
                        Image.network(
                          widget.order.items[i].images[0],
                          height: 120,
                          width: 120,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.order.items[i].name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text("Quantity: ${widget.order.quantity[i]}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Tracking",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Stepper(
                currentStep: currentStep,
                controlsBuilder: (context, details)  {
                  if(user.type == "admin") {
                    return CustomButton(text: 'Done', onTap: () =>changeOrderStatus(details.currentStep));
                  }
                  return const SizedBox(height: 10,);
                },
                steps: [
                  Step(
                    title: const Text("Pending"),
                    content: const Text("Your order is yet to be delivered"),
                    isActive: currentStep > 0,
                    state: currentStep > 0 ? StepState.complete : StepState.indexed,
                  ),
                  Step(
                    title: const Text("In processing"),
                    content: const Text("Your order is being processed by our chefs"),
                    isActive: currentStep > 1,
                    state: currentStep > 1 ? StepState.complete : StepState.indexed,
                  ),
                  Step(
                    title: const Text("Received"),
                    content: const Text("Your order is delivered"),
                    isActive: currentStep > 2,
                    state: currentStep > 2 ? StepState.complete : StepState.indexed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

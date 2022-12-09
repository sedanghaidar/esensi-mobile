import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAgendaController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDate = TextEditingController();
  final TextEditingController controllerTime = TextEditingController();
  final TextEditingController controllerLocation = TextEditingController();
  final TextEditingController controllerDateTime = TextEditingController();
  final TextEditingController controllerDateEnd = TextEditingController();
  final TextEditingController controllerTimeEnd = TextEditingController();
  RxBool isParticiationLimit = false.obs;
}

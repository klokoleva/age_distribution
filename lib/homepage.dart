import 'package:agedistribution/agemodel.dart';
import 'package:agedistribution/httpservice.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  ValueNotifier<Country?> selectedCountry = ValueNotifier(null);
  ValueNotifier<bool> loading = ValueNotifier(false);

  submit() async {
    if (nameController.text.isEmpty || countryController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Warning'),
            content: Text('Form must be fill !'),
            actions: [
              FilledButton.tonal(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'))
            ],
          );
        },
      );
    } else {
      try {
        loading.value = true;
        AgeModel data = await services(
            nameController.text, selectedCountry.value!.countryCode);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Result in ${selectedCountry.value?.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.face_6_sharp, size: 64),
                  SizedBox(height: 24),
                  Text('Name : ${data.name!}'),
                  Text('Age : ${data.age!.toString()} y old'),
                  Text('Country :${data.countryId!}'),
                  Text('Total : ${data.count!.toString()}'),
                ],
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
        loading.value = false;
      } catch (e) {
        loading.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget countryyDesc(String title, String sub) {
      return ListTile(
        dense: true,
        title: Text(title),
        subtitle: Text(sub),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Age Distribution')),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  label: Text('Name'),
                ),
                onFieldSubmitted: (value) {
                  nameController.text = value;
                },
              ),
              TextFormField(
                controller: countryController,
                readOnly: true,
                decoration: InputDecoration(label: Text('Country')),
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode:
                        true, // optional. Shows phone code before the country name.
                    onSelect: (Country country) {
                      selectedCountry.value = country;
                      countryController.text = country.displayName;
                    },
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: selectedCountry,
                builder: (context, value, child) {
                  if (value != null) {
                    return Container(
                      color: Colors.brown.withOpacity(0.1),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: Text('Country Detail :'),
                        children: [
                          countryyDesc(value.displayName, 'displayName'),
                          countryyDesc(value.flagEmoji, 'flagEmoji'),
                          countryyDesc(value.name, 'name'),
                          countryyDesc(value.phoneCode, 'phoneCode'),
                          countryyDesc(value.e164Key, 'e164Key'),
                          countryyDesc(value.level.toString(), 'level'),
                          countryyDesc(value.name, 'name'),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              SizedBox(height: 32),
              FilledButton(
                onPressed: submit,
                style: FilledButton.styleFrom(
                    fixedSize: Size(double.infinity, 65)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: loading,
                      builder: (context, value, child) {
                        return value == true
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Press to know age');
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TelaEmpresa extends StatefulWidget {
  const TelaEmpresa({Key? key}) : super(key: key);

  @override
  _TelaEmpresaState createState() => _TelaEmpresaState();
}

class _TelaEmpresaState extends State<TelaEmpresa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Empresa"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset("images/detalhe_empresa.png"),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Sobre a empresa",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.deepOrange
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum dignissim, mi vel sollicitudin aliquet, lorem purus lobortis sapien, in auctor est dui et mi. Ut scelerisque vulputate arcu feugiat vulputate. Nunc et purus ac arcu accumsan tincidunt ut id nulla. Phasellus sagittis porta lectus, id pretium sapien ultricies a. Sed laoreet pellentesque lectus, et dictum mauris. Suspendisse ac volutpat velit. Etiam fringilla pretium enim tempor laoreet. Suspendisse condimentum lacus vitae tempor dignissim. Vivamus rhoncus tortor at suscipit scelerisque. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Mauris a volutpat lectus, ut ornare risus. Fusce in sem risus. Mauris maximus est libero, vel tincidunt risus aliquet a. Curabitur quam nibh, aliquam vitae lorem quis, scelerisque porttitor mauris. Pellentesque cursus tortor quis diam varius, malesuada elementum tortor vehicula. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas."
                  "Mauris iaculis nulla in sem suscipit maximus. Vestibulum mollis fringilla magna in laoreet. Nulla eget nisi quam. Cras lacinia erat velit, ut euismod urna iaculis ullamcorper. Pellentesque rutrum sed magna maximus lobortis. Aenean iaculis semper ex, et placerat justo luctus eget. Integer lobortis feugiat massa et convallis."
                  "Mauris iaculis nulla in sem suscipit maximus. Vestibulum mollis fringilla magna in laoreet. Nulla eget nisi quam. Cras lacinia erat velit, ut euismod urna iaculis ullamcorper. Pellentesque rutrum sed magna maximus lobortis. Aenean iaculis semper ex, et placerat justo luctus eget. Integer lobortis feugiat massa et convallis."
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

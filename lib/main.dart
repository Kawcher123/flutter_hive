
import 'package:flutter/material.dart';
import 'package:flutter_universal_storage/flutter_universal_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await HiveService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final HiveService hiveService = HiveService();

  final TextEditingController _nameController=TextEditingController();

  final TextEditingController _ageController=TextEditingController();

  List userData=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDb();
  }

  initDb() async {

    await hiveService.createBox('myBox');

    await hiveService.createBox('myBox2');

    userData=hiveService.readAll('myBox');

    setState(() {

    });


    print('_MyHomePageState.initDb:$userData');

    // hiveService.add({'name': 'John1', 'age': 27},'myBox');
    // print('myBox:${hiveService.readAll('myBox')}');
    //
    //  await hiveService.addWithKey('person1', {'name': 'John1', 'age': 65},'myBox');
    //
    //  await hiveService.addWithKey('person2', {'name': 'Jame2', 'age': 50},'myBox2');
    //
    // hiveService.add({'name': 'John2', 'age': 45},'myBox2');
    // print('myBox2: ${hiveService.readAll('myBox2')}');
    //
    // var box2=await hiveService.getByKey('person2','myBox2');
    //
    // print('myBox2 data: $box2');
    //
    //
    //
    // print('myBox data search: ${hiveService.searchByName('john2','myBox')}');
    //
    // await hiveService.close();
  }


  add()
  {
    hiveService.add({'name': _nameController.text, 'age': _ageController.text},'myBox');
    setState(() {
      userData=hiveService.readAll('myBox');
    });

 _nameController.clear();
 _ageController.clear();
  }




  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Column(
             children: [
               TextField(
                 controller: _nameController,
                 keyboardType: TextInputType.name,
                 decoration: InputDecoration(
                   labelText: 'Name',
                   hintText: 'Name',
                   hintStyle: const TextStyle(
                     fontSize: 14,
                   ),


                   border:  OutlineInputBorder(
                     borderRadius:  const BorderRadius.all(
                       Radius.circular(10.0),
                     ),
                     borderSide:  BorderSide(
                       width: 2,
                       color: Theme.of(context).primaryColor,
                       // style: BorderStyle.solid,
                     ),
                   ),
                 ),

               ),
               const SizedBox(height: 15,),
               TextField(
                 controller: _ageController,
                 keyboardType: TextInputType.number,
                 decoration: InputDecoration(
                   labelText: 'Age',
                   hintText: 'Age',
                   hintStyle: const TextStyle(
                     fontSize: 14,
                   ),


                   border:  OutlineInputBorder(
                     borderRadius:  const BorderRadius.all(
                       Radius.circular(10.0),
                     ),
                     borderSide:  BorderSide(
                       width: 2,
                       color: Theme.of(context).primaryColor,
                       // style: BorderStyle.solid,
                     ),
                   ),
                 ),

               ),

               const SizedBox(height: 15,),
               GestureDetector(
                 onTap: ()
                 {
                   add();
                 },
                 child: Container(
                   height: 50,
                   width: size.width,
                   decoration: BoxDecoration(
                     color: Theme.of(context).primaryColor,
                     borderRadius: BorderRadius.circular(10)
                   ),
                   child: Center(child: Text('ADD',style: TextStyle(color: Colors.white),)),
                 ),
               )
             ],
           ),
         ),



            Column(
              children: List.generate(userData.length, (index)
              {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    child: ListTile(
                      title: Text(userData[index]['name']),
                      subtitle: Text(userData[index]['age']),
                    ),
                  ),
                );
              }),
            )

          ],
        ),
      ),
  // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

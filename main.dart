import 'dart:core';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';


void main() {
  runApp(
      MaterialApp(
          home:MyApp()
      )
      );
}
class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  getPermission()async{
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');

      var contacts = await ContactsService.getContacts(); //연락처 가져오기
      print(contacts);
      setState((){
        name = contacts;
      });



    } else if (status.isDenied) {
      print('거절됨');
      Permission.contacts.request();
    }
  }


  var a = 3;
  var name = [];
  var like = [0,0,0];
  var total = 3;


  addOne(){
    setState(()
    { total++;
    });
  }

  addName(a){
    setState((){
      name.add(a);
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child : Text('버튼'),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context){
                    return DialogUI( addOne : addOne, addName: addName );
              },
              );
            },
        ),
        appBar: AppBar(backgroundColor: Color(0xffDCE2F0,),
          title: Text(total.toString(), style: TextStyle(color: Color(0xff50586C),),
          ),centerTitle: false,actions:[IconButton(onPressed: (){getPermission();}, icon: Icon(Icons.contacts))],
        ),
        body: ListView.builder(// ListView는 무한스크롤,데이터 자동 반복문 , builder은 반복문
            itemCount: name.length,
            itemBuilder: (context, i) {
              print(i);
              return ListTile(
                leading : Image.asset('assets/profile.png'),//타일앞
                title : Text(name[i].givenName ?? '이름없음'),//타일이름 ( 중간 ?)
               
              );
            }
        ),
          bottomNavigationBar: BottomAppBar(
          child:Container(
            decoration: BoxDecoration(
              color: Color(0xffDCE2F0)//색상코드값 입력시 0xff 뒤에 #빼고 코드 입력
            ),
            height: 60,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, //row에서 mainAxis는 가로
             children: const
              [Icon(Icons.call),
               Icon(Icons.message),
                Icon(Icons.contact_page)]
            )
        )),
      );


  }
}
class DialogUI extends StatelessWidget {
 DialogUI ({Key? key, this.state, this.addOne, this.addName}) : super(key: key);
  final state;
  final addOne;
  final addName;

  var inputData = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            TextField(controller: inputData,),
            TextButton(child:Text('완료'),onPressed: (){
              var newContact = Contact();
              newContact.givenName = inputData.text; //새로운 연락처 만들기
              ContactsService.addContact(newContact); //만든 연락처 집어넣기
              addName(newContact);//Name state에도 저장
            },),
            TextButton(child: Text('취소'), onPressed: () {
              Navigator.pop(context);
            },)

          ],
        ),
      ),
    );
  }}


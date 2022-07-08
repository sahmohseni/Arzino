import 'package:arzino_final/Module/currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fa', 'IR'), // English, no country code
        ],
        home: Home());
  }
}

class Home extends StatefulWidget {
  Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> currency = [];

  Future getResponse(BuildContext cntx) async {
    var url =
        'https://sasansafari.com/flutter/api.php?access_key=flutter123456';
    var value = await http.get(Uri.parse(url));
    if (currency.isEmpty) {
      if (value.statusCode == 200) {
        List jsonList = convert.jsonDecode(value.body);
        if (jsonList.length > 0) {
          for (int i = 0; i < jsonList.length; i++) {
            setState(() {
              currency.add(Currency(
                  id: jsonList[i]['id'],
                  title: jsonList[i]['title'],
                  price: jsonList[i]['price'],
                  changes: jsonList[i]['changes'],
                  status: jsonList[i]['status']));
            });
          }
        }
      }
    }
    return value;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResponse(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 243, 243, 243),
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0, actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
            child: Image.asset('assets/images/icon.png'),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: const Text(
              'قیمت بروز ارز و سکه',
              style: TextStyle(
                  fontFamily: 'iransans',
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.asset('assets/images/menu_icon.png'),
                  )))
        ]),
        body: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 18, 8),
                  child: Image.asset('assets/images/q_icon.png'),
                ),
                Text('نرخ ارز آزاد چیست ؟',
                    style: TextStyle(
                        fontFamily: 'iransans',
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700))
              ],
            ),
//---------------------------------------------------------------------------------------------------------------------------------
//description's container
            Container(
              margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
              width: double.infinity,
              height: 70,
              child: Text(
                ' نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.',
                style: TextStyle(
                    fontFamily: 'iransans',
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w300),
              ),
            ),
//-----------------------------------------------------------------------------------------------------------------------------------
//title's container
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 130, 130, 130),
                  borderRadius: BorderRadius.circular(10000)),
              margin: EdgeInsets.fromLTRB(16, 6, 16, 0),
              width: double.infinity,
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'نام آزاد ارز',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'iransans',
                        color: Colors.white),
                  ),
                  Text('قیمت',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'iransans',
                          color: Colors.white)),
                  Text('تغییر',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'iransans',
                          color: Colors.white))
                ],
              ),
            ),
//---------------------------------------------------------------------------------------------------------------
//container's list
            Container(
              margin: EdgeInsets.fromLTRB(10, 8, 10, 0),
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 1.8,
//---------------------------------------------------------------------------------------------------------------
//Detailes container
              child: FutureBuilder(
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int position) {
                            return Container(
                              decoration: BoxDecoration(
                                  boxShadow: [BoxShadow(blurRadius: 0)],
                                  borderRadius: BorderRadius.circular(1000),
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              margin: EdgeInsets.fromLTRB(14, 8, 14, 0),
                              width: double.infinity,
                              height: 45,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    currency[position].title!,
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'iransans'),
                                  ),
                                  Text(currency[position].price!,
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: 'iransans')),
                                  Text(currency[position].changes!,
                                      style: currency[position].status == 'n'
                                          ? TextStyle(
                                              color: Color.fromARGB(
                                                  255, 158, 17, 52),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'iransans')
                                          : TextStyle(
                                              color: Colors.green,
                                              fontSize: 14,
                                              fontFamily: 'iransans',
                                              fontWeight: FontWeight.w300))
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            if (index % 10 == 0) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 14, 120, 161),
                                    borderRadius: BorderRadius.circular(1000),
                                    boxShadow: [BoxShadow(blurRadius: 0)]),
                                margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
                                width: double.infinity,
                                height: 45,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'کسب و کار خود را در اینجا تبلیغ کنید',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'iransans',
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                          itemCount: currency.length)
                      : Center(child: CircularProgressIndicator());
                },
                future: getResponse(context),
              ),
            ),
//------------------------------------------------------------------------------------------------------------------
//Refresh Button And Time Widget
            Container(
              margin: EdgeInsets.fromLTRB(40, 30, 50, 0),
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 17,
              child: Row(
                children: [
//-------------------------------------------------------------------------------------------------------------------
//Refresh Button
                  TextButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 202, 193, 255)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(1000)))),
                      onPressed: () {
                        currency.clear();
                        FutureBuilder(
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int position) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(blurRadius: 0)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(1000),
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
                                        margin:
                                            EdgeInsets.fromLTRB(14, 8, 14, 0),
                                        width: double.infinity,
                                        height: 45,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              currency[position].title!,
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: 'iransans'),
                                            ),
                                            Text(
                                                getPersianNumber(
                                                    currency[position]
                                                        .price
                                                        .toString()),
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: 'iransans')),
                                            Text(
                                                getPersianNumber(
                                                    currency[position]
                                                        .changes
                                                        .toString()),
                                                style: currency[position]
                                                            .status ==
                                                        'p'
                                                    ? TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontFamily: 'irasnasn')
                                                    : TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontFamily: 'irasnasn'))
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      if (index % 10 == 0) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 14, 120, 161),
                                              borderRadius:
                                                  BorderRadius.circular(1000),
                                              boxShadow: [
                                                BoxShadow(blurRadius: 0)
                                              ]),
                                          margin:
                                              EdgeInsets.fromLTRB(12, 8, 12, 0),
                                          width: double.infinity,
                                          height: 45,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'کسب و کار خود را در اینجا تبلیغ کنید',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'iransans',
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        );
                                      } else {
                                        return SizedBox.shrink();
                                      }
                                    },
                                    itemCount: currency.length)
                                : Center(child: CircularProgressIndicator());
                          },
                          future: getResponse(context),
                        );
                        _showSnackBar(context, 'بروزرسانی با موفقیت انجام شد');
                        _getTime();
                      },
                      icon: Icon(
                        CupertinoIcons.refresh_bold,
                        color: Colors.black,
                      ),
                      label: Text(
                        'بروزرسانی',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'iransans',
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 35, 4),
                    child: Text(
                      _getTime(),
                      style: TextStyle(
                          fontFamily: 'iransans',
                          fontSize: 13,
                          fontWeight: FontWeight.w300),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}

String _getTime() {
  DateTime now = DateTime.now();
  return 'آخرین بروزرسانی' + DateFormat('kk:mm:ss').format(now);
}

_showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 200),
      content: Text(
        msg,
        style: TextStyle(
            fontSize: 14,
            fontFamily: 'iransans',
            color: Colors.white,
            fontWeight: FontWeight.w300),
      )));
}

String getPersianNumber(String number) {
  const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  en.forEach((element) {
    number = number.replaceAll(element, fa[en.indexOf(element)]);
  });
  return number;
}

import 'package:arzino/Module/Currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:developer' as developer;
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('fa', 'IR'), // English, no country code
      ],
      home: Home(),
    );
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

  Future getRespone(BuildContext cntx) async {
    // var url = '';
    var url =
        'https://sasansafari.com/flutter/api.php?access_key=flutter123456';
    var value = await http.get(Uri.parse(url));
    if (currency.isEmpty) {
      if (value.statusCode == 200) {
        _showSnackBar(context, "بروزرسانی اطلاعات با موفقیت انجام شد");
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
    ;
    return value;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRespone(context);
  }

  @override
  Widget build(BuildContext context) {
    _getTime();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 16, 6),
            child: Image.asset('assets/images/icon.png'),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: const Text(
              'قیمت به روز ارز',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'iransans',
                  fontSize: 16),
            ),
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 6, 18, 6),
                    child: Image.asset('assets/images/menu_icon.png'),
                  )))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //title's 1 container
            Container(
              margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
              width: double.infinity,
              height: 30,
              child: Row(
                children: [
                  Image.asset('assets/images/questionMark_icon.png'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 8, 3),
                    child: const Text('نرخ ارز آزاد چیست ؟',
                        style: TextStyle(
                            fontFamily: 'iransans',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black)),
                  )
                ],
              ),
            ),
            //--------------------------------------------------------------------------------------------------------------------------
            //description 1
            Container(
              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
              width: double.infinity,
              height: 80,
              child: Text(
                'نرخ ارزها در معاملات نقدی و رایج روزانه است،معاملات نقدی معاملاتی\nهستند که خریدار و فروشنده به محض انجام معامله،ارز و ریال را باهم\nتبادل می نمایند',
                style: TextStyle(
                    fontFamily: 'iransans',
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w300),
              ),
              // -------------------------------------------------------------------------------------------------------------------------
              //title's container
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 6),
              width: double.infinity,
              height: 30,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 130, 130, 130),
                  borderRadius: BorderRadius.circular(1000)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'نام آزاد ارز',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'iransans',
                        fontWeight: FontWeight.w300),
                  ),
                  Text('قیمت',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'iransans',
                          fontWeight: FontWeight.w300)),
                  Text('تغییر',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'iransans',
                          fontWeight: FontWeight.w300))
                ],
              ),
            ),
            //---------------------------------------------------------------------------------------------------------------------------
            //list's container
            Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2,
                child: FutureBuilder(
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int position) {
                              return Container(
                                decoration: BoxDecoration(
                                    boxShadow: [BoxShadow(blurRadius: 0)],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(1000)),
                                margin: EdgeInsets.fromLTRB(6, 0, 6, 8),
                                width: double.infinity,
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        currency[position].title!,
                                        style: TextStyle(
                                            fontFamily: 'iransans',
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                          getFarsiNumber(currency[position]
                                              .price
                                              .toString()),
                                          style: TextStyle(
                                              fontFamily: 'iransans',
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300)),
                                    ),
                                    Text(
                                        getFarsiNumber(currency[position]
                                            .changes
                                            .toString()),
                                        style: currency[position].status == 'p'
                                            ? TextStyle(
                                                fontFamily: 'iransans',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green)
                                            : TextStyle(
                                                fontFamily: 'iransans',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 213, 6, 26)))
                                  ],
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              if (index % 10 == 0) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 60, 203, 210),
                                      borderRadius:
                                          BorderRadius.circular(1000)),
                                  margin: EdgeInsets.fromLTRB(6, 0, 6, 8),
                                  width: double.infinity,
                                  height: 40,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: const Text(
                                        'کسب و کار خود را در اینجا ارزینو تبلیغ کنید',
                                        style: TextStyle(
                                            fontFamily: 'iransans',
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300)),
                                  ),
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            },
                            itemCount: currency.length)
                        : Center(child: CircularProgressIndicator());
                  },
                  future: getRespone(context),
                )),
            //-------------------------------------------------------------------------------------------------------------------------------------------
            //refresh button and time button 's container
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 232, 232, 232),
                  borderRadius: BorderRadius.circular(10000)),
              margin: EdgeInsets.fromLTRB(12, 20, 20, 0),
              width: double.infinity,
              height: 40,
              child: Row(
                children: [
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
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(1000)),
                                        margin: EdgeInsets.fromLTRB(6, 0, 6, 8),
                                        width: double.infinity,
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                currency[position].title!,
                                                style: TextStyle(
                                                    fontFamily: 'iransans',
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                  getFarsiNumber(
                                                      currency[position]
                                                          .price
                                                          .toString()),
                                                  style: TextStyle(
                                                      fontFamily: 'iransans',
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w300)),
                                            ),
                                            Text(
                                                getFarsiNumber(currency[
                                                        position]
                                                    .changes
                                                    .toString()),
                                                style: currency[position]
                                                            .status ==
                                                        'p'
                                                    ? TextStyle(
                                                        fontFamily: 'iransans',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.green)
                                                    : TextStyle(
                                                        fontFamily: 'iransans',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromARGB(
                                                            255, 213, 6, 26)))
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
                                                  255, 60, 203, 210),
                                              borderRadius:
                                                  BorderRadius.circular(1000)),
                                          margin:
                                              EdgeInsets.fromLTRB(6, 0, 6, 8),
                                          width: double.infinity,
                                          height: 40,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: const Text(
                                                'کسب و کار خود را در اینجا ارزینو تبلیغ کنید',
                                                style: TextStyle(
                                                    fontFamily: 'iransans',
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                          ),
                                        );
                                      } else {
                                        return SizedBox.shrink();
                                      }
                                    },
                                    itemCount: currency.length)
                                : Center(child: CircularProgressIndicator());
                          },
                          future: getRespone(context),
                        );
                      },
                      icon: Icon(
                        CupertinoIcons.refresh_bold,
                        color: Colors.black,
                      ),
                      label: Text(
                        'بروزرسانی',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'iransans',
                            fontSize: 16),
                      )),
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                        child: Text(
                          _getTime(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

void _showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.amberAccent,
    content: Text(
      msg,
      style: TextStyle(
          fontSize: 14,
          fontFamily: 'iransans',
          color: Colors.white,
          fontWeight: FontWeight.w300),
    ),
  ));
}

String _getTime() {
  DateTime now = DateTime.now();
  return 'آخرین بروزرسانی' + DateFormat('kk:mm:ss').format(now);
}

String getFarsiNumber(String number) {
  const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  en.forEach((element) {
    number = number.replaceAll(element, fa[en.indexOf(element)]);
  });
  return number;
}

import 'package:corona/card.dart';
import 'package:flutter/material.dart';
import 'corona_serice.dart';
import 'package:corona/models/corona_case_country.dart';
import 'package:corona/models/corona_case_total_count.dart';
import 'package:corona/utils/utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CountryPage extends StatefulWidget {
  CountryPage({Key key}) : super(key: key);

  @override
  _CountryPage createState() => _CountryPage();
}

class _CountryPage extends State<CountryPage>
    with AutomaticKeepAliveClientMixin<CountryPage> {
  @override
  bool get wantKeepAlive => true;

  var service = CoronaService.instance;
 
  Future<List<CoronaCaseCountry>> _allCasesFuture;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  _fetchData() {
    
    _allCasesFuture = service.fetchCases();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: Container(
            constraints: BoxConstraints(maxWidth: 768),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: <Widget>[
                
                  _buildAllCasesWidget(context)
                ],
              ),
            )));
  }

  Widget _buildAllCasesWidget(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
     double width=MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: _allCasesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.error != null) {
          return Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Center(
                child: Text('Error fetching total cases global data'),
              ));
        } else {
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Center(child: Text("No Data")),
            );
          }

          final List<CoronaCaseCountry> cases = snapshot.data;
          //allcases
          print(cases.length);
          

          
          

        

          return SafeArea(
                      child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8,left: 8,right: 8,bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Container(
                             
                            ),
                          ),
                          Text("Crucial")
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.blue,
                            child: Container(),
                          ),
                          Text("Moderate")
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.green,
                            child: Container(),
                          ),
                          Text("Safe")
                        ],
                      )

                    ],
                  ),
                ),
                Container(
                  height: height-120,
                  width: width,
                  child:ListView.builder(
                    itemCount: cases.length,
                    itemBuilder: (context,int i){
                      if(cases[i].totalConfirmedCount>1000){
                        return EasyCard(
                        prefixBadge: Colors.red,
                        title: cases[i].country,
                        description: "Confirmed: "+cases[i].totalConfirmedCount.toString()+"   "+"Deaths: "+cases[i].totalDeathsCount.toString()+"   "+"Recovered: "+cases[i].totalRecoveredCount.toString(),

                      );

                      }
                      if(cases[i].totalConfirmedCount<1000 && cases[i].totalConfirmedCount>=500){
                        return EasyCard(
                        prefixBadge: Colors.blue,
                        title: cases[i].country,
                        description: "Confirmed: "+cases[i].totalConfirmedCount.toString()+"   "+"Deaths: "+cases[i].totalDeathsCount.toString()+"   "+"Recovered: "+cases[i].totalRecoveredCount.toString(),

                      );

                      }
                      if(cases[i].totalConfirmedCount<500 && cases[i].totalConfirmedCount>=0){
                        return EasyCard(
                        prefixBadge: Colors.green,
                        title: cases[i].country,
                        description: "Confirmed: "+cases[i].totalConfirmedCount.toString()+"   "+"Deaths: "+cases[i].totalDeathsCount.toString()+"   "+"Recovered: "+cases[i].totalRecoveredCount.toString(),

                      );

                      }
                      
                    }) ,
                  ),
              ],
            ),
          );
        }
      },
    );
  }
}

enum CaseType { confirmed, deaths, recovered, sick }

class LinearCases {
  final int type;
  final int count;
  final int total;
  final String text;

  LinearCases(this.type, this.count, this.total, this.text);
}

class OrdinalCases {
  final String country;
  final int total;
  final CoronaTotalCount totalCount;

  OrdinalCases(this.country, this.total, this.totalCount);
}
import 'package:corona/card.dart';
import 'package:flutter/material.dart';
import 'corona_serice.dart';
import 'package:corona/models/corona_case_country.dart';
import 'package:corona/models/corona_case_total_count.dart';


class StatsPage extends StatefulWidget {
  StatsPage({Key key}) : super(key: key);

  @override
  _StatsPage createState() => _StatsPage();
}

class _StatsPage extends State<StatsPage>
    with AutomaticKeepAliveClientMixin<StatsPage> {
  @override
  bool get wantKeepAlive => true;

  var service = CoronaService.instance;
  Future<CoronaTotalCount> _totalCountFuture;
  Future<List<CoronaCaseCountry>> _allCasesFuture;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  _fetchData() {
    _totalCountFuture = service.fetchAllTotalCount();
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
                  _buildTotalCountWidget(context),
                  
                  
                ],
              ),
            )));
  }

  Widget _buildTotalCountWidget(BuildContext context) {
    return FutureBuilder(
        future: _totalCountFuture,
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
                  child: Text('Error fetching total count data'),
                ));
          } else {
            //totalinnfo
            
            final CoronaTotalCount totalCount = snapshot.data;
            
            

            
            return Padding(
              padding: const EdgeInsets.only(left: 10,top: 90),
              child: Container(
                child: Column(
                  children: <Widget>[
                    EasyCard(
                        prefixBadge: Colors.red[400],
                        
                        iconColor: Colors.red[400],
                        title: "Total global confirmed cases-"+totalCount.confirmed.toString(),
                        
                      
              ),
               EasyCard(
                        prefixBadge: Colors.black,
                        
                        
                        title: "Total global death cases-"+totalCount.deaths.toString(),
                        
                        
              ),
               EasyCard(
                        prefixBadge: Colors.green[400],
                        
                        
                        title: "Total global recovered cases-"+totalCount.recovered.toString(),
                        
                        
              ),
               EasyCard(
                        prefixBadge: Colors.blue[400],
                        
                        
                        
                        title: "Recovery Rate-"+totalCount.recoveryRate.ceil().toString()+"%",
                        
                        
              ),
               EasyCard(
                        prefixBadge: Colors.orange[400],
                        
                        
                        
                        title: "Total global sick cases-"+totalCount.sick.toString(),
                        
                        
              ),
              EasyCard(
                        prefixBadge: Colors.black,
                        suffixIcon: Icons.cancel,
                        
                        
                        
                        title: "Fatality Rate-"+totalCount.fatalityRate.ceil().toString()+"%",
                        
                        
              ),

                  ],
                ),
              ),
            );
          }
        });
  }
    }

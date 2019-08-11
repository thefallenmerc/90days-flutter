import 'package:carousel_slider/carousel_slider.dart';
import 'package:days90/widgets/drawer.dart';
import 'package:days90/widgets/performance_card.dart';
import 'package:days90/widgets/resolution_card.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/main_model.dart';

class MyHomePage extends StatefulWidget {
  final MainModel model;
  MyHomePage(this.model);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    widget.model.getResolutions(context);
    widget.model.selectedResolutionIndex = null;
    super.initState();
  }

  Widget _getPerformanceCards() {
    int _totalResolutions = widget.model.resolutionList.length;
    int _incompleteResolutions = widget.model.getIncompletedResolutionCount();
    int _completedResolutions = widget.model.getCompletedResolutionCount();
    int _failedResolutions = widget.model.getFailedResolutionCount();
    return Row(
      children: <Widget>[
        PerformanceCard(_totalResolutions, 'Total', Colors.orange),
        PerformanceCard(_completedResolutions, 'Complete', Colors.green),
        PerformanceCard(_incompleteResolutions, 'Incomplete', Colors.blue),
        PerformanceCard(_failedResolutions, 'Failed', Colors.red),
      ],
    );
  }

  Widget _getBanners() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200.0,
      child: PageView(
        children: <Widget>[
          Container(
            color: Colors.pink,
          ),
          Container(
            color: Colors.cyan,
          ),
          Container(
            color: Colors.deepPurple,
          ),
        ],
      ),
    );
  }

  Widget _getCarousel() {
    return Container(
      child: CarouselSlider(
        height: 200.0,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: Duration(milliseconds: 1),
        items: <Widget>[
          Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), color: Colors.red),
            child: Center(
              child: Text('lol'),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), color: Colors.green),
            child: Center(
              child: Text('lol'),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), color: Colors.blue),
            child: Center(
              child: Text('lol'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        model.setSelectedResolutionIndex = null;
        return Scaffold(
            appBar: AppBar(
              title: Text('90 Days'),
            ),
            drawer: SideDrawer(widget.model),
            body: model.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          // _getBanners(),
                          // _getCarousel(),
                          _getPerformanceCards(),
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return Hero(
                                  child: ResolutionCard(model, index),
                                  tag: 'resolutionCard' + index.toString(),
                                );
                              },
                              itemCount: widget.model.resolutionList.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onRefresh: () {
                      widget.model.getResolutions(context);
                      return Future.value();
                    },
                  ));
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:show_time_for_flutter/ui/channel/channel.dart';
import 'package:show_time_for_flutter/ui/channel/channel_info.dart';
import 'package:show_time_for_flutter/ui/news/news_list.dart';

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  ChannelModel channelModel;
  List<Channel> tabs = [];
  List<String> videoTabs = ["史诗大片", "恢弘大剧", "本地视频"];
  List<String> bookTabs = ["书架", "分类", "社区", "排行榜"];
  List<String> musicTabs = ["本地音乐", "推荐歌单", "排行榜"];
  int _selectedIndex = 0;
  final _selectedTitles = [
    "新闻",
    "视频",
    "音乐爽听",
    "阅读",
  ];
  final _widgetOptions = [
    Text('Index 0: News'),
    Text('Index 1: Video'),
    Text('Index 2: Music'),
    Text('Index 3: Books'),
  ];
  int _selectDrawItemIndex = -1;
  TextStyle style = TextStyle(color: Colors.black);
  TabController _tabController;
  ScrollController _scrollViewController;

  @override
  void initState() {
    super.initState();
    channelModel = new ChannelModel();
    initSelectChannels();
    _tabController = TabController(vsync: this, length: tabs.length);
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
    _scrollViewController.addListener((){
      var position = _scrollViewController.position;
      print("position:$position");
    });
  }

  changeTabController() {
    _tabController = TabController(vsync: this, length: tabs.length);
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
  }

  initSelectChannels() async {
    tabs = await channelModel.getSelectChannels();
    setState(() {
      changeTabController();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  List<Widget> buildTabs() {
    List<Widget> widgets = new List<Widget>();
    if (_selectedIndex == 0) {
      widgets = tabs.map((channel) {
        return new Tab(
          text: channel.name,
        );
      }).toList();
    } else if (_selectedIndex == 1) {
      widgets = videoTabs.map((title) {
        return new Tab(
          text: title,
        );
      }).toList();
    } else if (_selectedIndex == 2) {
      widgets = musicTabs.map((title) {
        return new Tab(
          text: title,
        );
      }).toList();
    } else if (_selectedIndex == 3) {
      widgets = bookTabs.map((title) {
        return new Tab(
          text: title,
        );
      }).toList();
    }

    return widgets;
  }

  bool _isScrollable() {
    if (_selectedIndex == 0) {
      //||_selectedIndex==1
      return true;
    } else {
      return false;
    }
  }

  List<Widget> buildTabViewPage() {
    List<Widget> widgets = new List<Widget>();
    if (_selectedIndex == 0) {
      widgets = tabs.map((channel) {
        return new NewsListPage(
          typeId: channel.typeId,
        );
      }).toList();
    } else if (_selectedIndex == 1) {
      widgets = videoTabs.map((title) {
        return new Text(title);
      }).toList();
    } else if (_selectedIndex == 2) {
      widgets = musicTabs.map((title) {
        return new Text(title);
      }).toList();
    } else if (_selectedIndex == 3) {
      widgets = bookTabs.map((title) {
        return new Text(title);
      }).toList();
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedTitles.elementAt(_selectedIndex)),
        actions: _buildActions(),
        bottom: TabBar(
          isScrollable: _isScrollable(),
          controller: _tabController,
          tabs: buildTabs(),
        ),
      ),
      body: TabBarView(
        children: buildTabViewPage(),
        controller: _tabController,
      ),
//      NestedScrollView(
//          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
//            return <Widget>[
//              SliverAppBar(
//                title: Text(_selectedTitles.elementAt(_selectedIndex)),
//                actions: _buildActions(),
//                pinned: true,
//                floating: true,
//                forceElevated: boxIsScrolled,
//                bottom: TabBar(
//                  isScrollable: _isScrollable(),
//                  controller: _tabController,
//                  tabs: buildTabs(),
//                ),
//              )
//            ];
//          },
//          controller: _scrollViewController,
//          body: TabBarView(
//            children: buildTabViewPage(),
//            controller: _tabController,
//          )),
      drawer: Drawer(
        child: _onDrawViewPage(),
      ),
      bottomNavigationBar: Theme(
          data: ThemeData(
              canvasColor: Colors.red,
              textTheme: Theme.of(context).textTheme.copyWith(caption: style)),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: _selectIconColor(0),
                  ),
                  title: Text(
                    'News',
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.video_label,
                    color: _selectIconColor(1),
                  ),
                  title: Text(
                    'Video',
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.queue_music,
                    color: _selectIconColor(2),
                  ),
                  title: Text(
                    'Music',
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.collections_bookmark,
                    color: _selectIconColor(3),
                  ),
                  title: Text(
                    'Books',
                  )),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
//             这两个属性一起用才起作用
//            fixedColor: Colors.deepPurple,
//            type: BottomNavigationBarType.fixed,
          )),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      changeTabController();
    });
  }

  Color _selectIconColor(int index) {
    return _selectedIndex == index ? Colors.white : Colors.grey;
  }

  List<Widget> _buildActions() {
    if (_selectedIndex == 0) {
      return <Widget>[
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ChannelPage();
              })).then((value) {
                setState(() {
                  tabs = value;
                  changeTabController();
                });
              });
            })
      ];
    } else if (_selectedIndex == 1) {
      return [];
    } else if (_selectedIndex == 2) {
      return <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
//              Navigator.of(context)
//                  .push(MaterialPageRoute(builder: (context) {
//                return ChannelPage();
//              })).then((value) {
//                tabs = value;
//                setState(() {
//                  changeTabController();
//                });
//              });
            })
      ];
    } else if (_selectedIndex == 3) {
      return <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
      ];
    }
  }

  Widget _onDrawViewPage() {
    return Column(
      children: <Widget>[
        const UserAccountsDrawerHeader(
          accountName: Text('ShowTime'),
          accountEmail: Text('zcphappyghost@163.com'),
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage(
              'assets/images/drawhead.png',
            ),
          ),
          margin: EdgeInsets.zero,
        ),
        gestureDetectorForItem(
            Icons.library_books, '段子', 0, _selectDrawItemIndex),
        gestureDetectorForItem(Icons.image, '图片', 1, _selectDrawItemIndex),
        gestureDetectorForItem(Icons.live_tv, '直播', 2, _selectDrawItemIndex),
        gestureDetectorForItem(Icons.settings, '设置', 3, _selectDrawItemIndex),
      ],
    );
  }

  GestureDetector gestureDetectorForItem(IconData icon, String title,
      int drawItemIndex, int _selectDrawItemIndex) {
    return GestureDetector(
      child: Container(
        color:
            _selectDrawItemIndex == drawItemIndex ? Colors.grey : Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              child: Icon(
                icon,
                color: _selectDrawItemIndex == drawItemIndex
                    ? Colors.red
                    : Colors.grey,
              ),
              margin: EdgeInsets.all(16.0),
            ),
            Container(
              child: Text(
                title,
                style: TextStyle(
                    color: _selectDrawItemIndex == drawItemIndex
                        ? Colors.red
                        : Colors.black),
              ),
              margin: EdgeInsets.all(16.0),
            )
          ],
        ),
      ),
      onTap: () {
        _onDrawItemSelect(drawItemIndex);
      },
    );
  }

  _onDrawItemSelect(int drawItemIndex) {
    _selectDrawItemIndex = drawItemIndex;
    setState(() {});
  }
}
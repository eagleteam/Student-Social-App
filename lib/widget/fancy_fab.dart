import 'package:flutter/material.dart';

class FancyFab extends StatefulWidget {
  final Function onPressedFab;
  final String type;
  static const String xemdiem = "xemdiem";
  static const String xemlich = "xemlich";
  //const define click tag
  static const String themghichu = "themghichu";
  static const String capnhatlich = "capnhatlich";
  static const String loc = "loc";
  static const String capnhatdiem = "capnhatdiem";

  FancyFab({this.onPressedFab, this.type});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget textContentLoc() {
    if (isOpened) {
      return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: Colors.green),
          child: Text(
            'Bộ lọc',
            style: TextStyle(color: Colors.white),
          ));
    } else {
      return Container();
    }
  }

  Widget textContentAddGhiChu() {
    if (isOpened) {
      return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: Colors.green),
          child: Text(
            'Thêm ghi chú',
            style: TextStyle(color: Colors.white),
          ));
    } else {
      return Container();
    }
  }

  Widget textContentUpdateDiem() {
    if (isOpened) {
      return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: Colors.green),
          child: Text(
            'Cập nhật điểm',
            style: TextStyle(color: Colors.white),
          ));
    } else {
      return Container();
    }
  }

  Widget textContentUpdateLich() {
    if (isOpened) {
      return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: Colors.green),
          child: Text(
            'Cập nhật lịch',
            style: TextStyle(color: Colors.white),
          ));
    } else {
      return Container();
    }
  }

  Widget addGhiChu() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          textContentAddGhiChu(),
          Padding(
            padding: const EdgeInsets.only(right: 8),
          ),
          FloatingActionButton(
            heroTag: 'addghichu',
            onPressed: () {
              if (isOpened){
                animate();
                widget.onPressedFab(FancyFab.themghichu);
              }
            },
            tooltip: 'Add',
            child: Icon(Icons.note_add),
          ),
        ],
      ),
    );
  }

  Widget Loc() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          textContentLoc(),
          Padding(
            padding: const EdgeInsets.only(right: 8),
          ),
          FloatingActionButton(
            heroTag: 'loc',
            onPressed: () {
              if (isOpened){
                animate();
                widget.onPressedFab(FancyFab.loc);
              }
            },
            tooltip: 'Loc',
            child: Icon(Icons.filter_list),
          ),
        ],
      ),
    );
  }

  Widget updateDiem() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          textContentUpdateDiem(),
          Padding(
            padding: const EdgeInsets.only(right: 8),
          ),
          FloatingActionButton(
            heroTag: 'updatediem',
            onPressed: () {
              if (isOpened){
                animate();
                widget.onPressedFab(FancyFab.capnhatdiem);
              }
            },
            tooltip: 'Update',
            child: Icon(Icons.update),
          ),
        ],
      ),
    );
  }

  Widget updateLich() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          textContentUpdateLich(),
          Padding(
            padding: const EdgeInsets.only(right: 8),
          ),
          FloatingActionButton(
            heroTag: 'updatelich',
            onPressed: () {
              if (isOpened){
                animate();
                widget.onPressedFab(FancyFab.capnhatlich);
              }
            },
            tooltip: 'Update',
            child: Icon(Icons.update),
          ),
        ],
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        heroTag: 'toggle',
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.add_event,
          progress: _animateIcon,
        ),
      ),
    );
  }

  List<Widget> getWidgetByType() {
    if (widget.type == FancyFab.xemlich) {
      return [
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: addGhiChu(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: updateLich(),
        ),
        toggle()
      ];
    } else if (widget.type == FancyFab.xemdiem) {
      return [
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: Loc(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: updateDiem(),
        ),
        toggle()
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: getWidgetByType());
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Remove the MaterialApp wrapper
    return DashboardScreen(); // Directly return the DashboardScreen
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/classroom2.png'), // Replace 'assets/background_image.jpg' with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          NavigationWrapper(
            body: _getBody(_selectedIndex),
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return Item1Screen();
      case 2:
        return Item2Screen();
      default:
        return HomeScreen();
    }
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Positioned text with adjustable padding
        Positioned(
          top: 50.0,
          left: 80.0,
          child: Text(
            '',
            style: GoogleFonts.lato(fontSize: 18.0, color: Colors.black),
          ),
        ),
        Center(
          child: Center(
            child: PhysicalModel(
              color: Colors.red.shade300, // Button background color
              elevation: 4.0, // Adjust button elevation (shadow depth)
              borderRadius: BorderRadius.circular(10.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'qr');
                },
                child: Text(
                  'Generate QR',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
                style: TextButton.styleFrom(
                  minimumSize: Size(200.0, 70.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Item1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item 1 Screen'),
      ),
      body: Center(
        child: Text('This is Item 1 Screen'),
      ),
    );
  }
}

class Item2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item 2 Screen'),
      ),
      body: Center(
        child: Text('This is Item 2 Screen'),
      ),
    );
  }
}

class NavigationRailWidget extends StatefulWidget {
  final void Function(int) onDestinationSelected;

  NavigationRailWidget({required this.onDestinationSelected});

  @override
  _NavigationRailWidgetState createState() => _NavigationRailWidgetState();
}

class _NavigationRailWidgetState extends State<NavigationRailWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.green.shade500,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: NavigationRail(
        groupAlignment: 0,
        backgroundColor: Colors.transparent,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          widget.onDestinationSelected(index);
        },
        labelType: NavigationRailLabelType.selected,
        destinations: [
          NavigationRailDestination(
            icon: Icon(Icons.home),
            selectedIcon: Icon(Icons.home),
            label: Text('Home'),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.qr_code),
            selectedIcon: Icon(Icons.qr_code),
            label: Text('QR'),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.settings),
            selectedIcon: Icon(Icons.settings),
            label: Text('Settings'),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        ],
      ),
    );
  }
}

class NavigationWrapper extends StatelessWidget {
  final Widget body;
  final int selectedIndex;
  final void Function(int) onItemSelected;

  NavigationWrapper({
    required this.body,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRailWidget(onDestinationSelected: onItemSelected),
        Expanded(
          child: body,
        ),
      ],
    );
  }
}

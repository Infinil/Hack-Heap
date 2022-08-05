import 'barrel.dart';

class HackathonsPage extends StatefulWidget {
  const HackathonsPage({Key? key}) : super(key: key);

  @override
  State<HackathonsPage> createState() => _HackathonsPageState();
}

class _HackathonsPageState extends State<HackathonsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 34, 45, 52),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 53, 79, 82),
          title: const Text('Hack Heap'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(onPressed: (){}, icon: const Icon(Icons.refresh, size: 28,)),
            )
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text(
                  'Devfolio',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16
                  ),
                )
              ),
              Tab(
                child: Text(
                  'Hackerearth',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16
                  ),
                )
              ),
              Tab(
                child: Text(
                  'MLH',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16
                  ),
                )
              ),
            ]
          )
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
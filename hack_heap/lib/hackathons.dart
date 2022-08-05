import 'barrel.dart';

class HackathonsPage extends StatefulWidget {
  const HackathonsPage({Key? key}) : super(key: key);

  @override
  State<HackathonsPage> createState() => _HackathonsPageState();
}

class _HackathonsPageState extends State<HackathonsPage> {
  final List<String> tabs = ['Devfolio', 'Hackerearth', 'MLH'];

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
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text(
                  tabs.elementAt(0),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16
                  ),
                )
              ),
              Tab(
                child: Text(
                  tabs.elementAt(1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16
                  ),
                )
              ),
              Tab(
                child: Text(
                  tabs.elementAt(2),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16
                  ),
                )
              ),
            ]
          )
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              HackathonPage(selectedSource: tabs.elementAt(0)),
              HackathonPage(selectedSource: tabs.elementAt(1)),
              HackathonPage(selectedSource: tabs.elementAt(2)),
            ],
          ),
        ),
      ),
    );
  }
}

class HackathonPage extends ConsumerStatefulWidget {
  const HackathonPage({required this.selectedSource, Key? key}) : super(key: key);
  final String selectedSource;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HackathonPageState();
}

class _HackathonPageState extends ConsumerState<HackathonPage> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class HackathonCard extends ConsumerStatefulWidget {
  const HackathonCard({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HackathonCardState();
}

class _HackathonCardState extends ConsumerState<HackathonCard> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
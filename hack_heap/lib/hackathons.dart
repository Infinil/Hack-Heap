import 'package:appwrite/appwrite.dart';

import 'barrel.dart';
import 'package:appwrite/models.dart';

class HackathonsPage extends StatefulWidget {
  const HackathonsPage({Key? key}) : super(key: key);

  @override
  State<HackathonsPage> createState() => _HackathonsPageState();
}

class _HackathonsPageState extends State<HackathonsPage> {
  final List<String> tabs = ['Devfolio', 'Hackerearth', 'MLH'];
  final ReloadTabsController _reloadTabsController = ReloadTabsController();

  void refreshTab() => _reloadTabsController.hackathonsReload();

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
              child: IconButton(
                onPressed: () {
                  refreshTab();
                }, 
                icon: const Icon(Icons.refresh, size: 32,)
              ),
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
              HackathonPage(reloadTabsController: _reloadTabsController, selectedSource: tabs.elementAt(0)),
              HackathonPage(reloadTabsController: _reloadTabsController, selectedSource: tabs.elementAt(1)),
              HackathonPage(reloadTabsController: _reloadTabsController, selectedSource: tabs.elementAt(2)),
            ],
          ),
        ),
      ),
    );
  }
}

class HackathonPage extends ConsumerStatefulWidget {
  const HackathonPage({required this.reloadTabsController, required this.selectedSource, Key? key}) : super(key: key);
  final ReloadTabsController reloadTabsController;
  final String selectedSource;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HackathonPageState();
}

class _HackathonPageState extends ConsumerState<HackathonPage> {
  late Future<List<HackathonDocument>> _allHackathons;

  void _refreshHackathons() {
    _allHackathons = _fetchHackathons();
    if (mounted) setState(() {});
  }

  Future<List<HackathonDocument>> _fetchHackathons() async {
    final List<HackathonDocument> allHackathons = [];
    final DocumentList fetchedDocuments = await ref.read(appwriteDatabaseProvider).listDocuments(
      collectionId: ref.read(hackathonsCIDProvider),
      queries: [ 
        Query.equal('source', widget.selectedSource)
      ],
      limit: 100,
      offset: 0,
      orderAttributes: ['date'],
      orderTypes: ['ASC']
    );
    for (final Document currentDoc in fetchedDocuments.documents) {
      allHackathons.add(
        HackathonDocument(
          name: currentDoc.data['name'],
          participants: currentDoc.data['participants'],
          mode: currentDoc.data['mode'],
          timeline: currentDoc.data['timeline'],
          date: currentDoc.data['date'],
          image: currentDoc.data['image'],
          url: currentDoc.data['url']
        )
      );
    }
    return allHackathons;
  }

  @override
  void initState() {
    super.initState();
    widget.reloadTabsController.hackathonsReload = _refreshHackathons;
    _allHackathons = _fetchHackathons();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HackathonDocument>>(
      future: _allHackathons,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
              children: snapshot.data!.map(
                (currentDocument) {
                  return HackathonCard();
                }
              ).toList(),
            ),
          );
        }
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ); 
        }
        else {
          return const Center(
            child: Icon(
              Icons.error,
              color: Colors.red,
              size: 50,
            ),
          ); 
        }
      }
    );
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
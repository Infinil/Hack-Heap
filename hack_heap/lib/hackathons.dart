import 'barrel.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';


class HackathonsPage extends StatefulWidget {
  const HackathonsPage({Key? key}) : super(key: key);

  @override
  State<HackathonsPage> createState() => _HackathonsPageState();
}

class _HackathonsPageState extends State<HackathonsPage> {
  final List<String> tabs = ['Devfolio', 'Hackerearth', 'MLH'];
  final ForwardController _forwardController = ForwardController();

  void refreshTab() => _forwardController.hackathonsReload();

  @override
  void initState() {
    super.initState();
    _forwardController.initializeSettings();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 15, 44, 80),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 58, 78, 122),
          title: const Text('Hack Heap'),
          actions: [
            IconButton(
              onPressed: () {
                if (
                  _forwardController.notificationTitle != null 
                  && _forwardController.notificationDescription != null
                  && Platform.isAndroid
                ) {
                  _forwardController.showNotifications();
                }
              }, 
              icon: const Icon(Icons.notifications, size: 28,)
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                onPressed: () {
                  refreshTab();
                }, 
                icon: const Icon(Icons.refresh, size: 28,)
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
                    fontSize: 17
                  ),
                )
              ),
              Tab(
                child: Text(
                  tabs.elementAt(1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17
                  ),
                )
              ),
              Tab(
                child: Text(
                  tabs.elementAt(2),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17
                  ),
                )
              ),
            ]
          )
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              HackathonPage(forwardController: _forwardController, selectedSource: tabs.elementAt(0)),
              HackathonPage(forwardController: _forwardController, selectedSource: tabs.elementAt(1)),
              HackathonPage(forwardController: _forwardController, selectedSource: tabs.elementAt(2)),
            ],
          ),
        ),
      ),
    );
  }
}

class HackathonPage extends ConsumerStatefulWidget {
  const HackathonPage({required this.forwardController, required this.selectedSource, Key? key}) : super(key: key);
  final ForwardController forwardController;
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
        Query.equal('source', widget.selectedSource),
        Query.greaterEqual('date', Jiffy().unix())
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
    widget.forwardController.notificationTitle = allHackathons.elementAt(0).name;
    widget.forwardController.notificationDescription = 'Starts from ${
      allHackathons.elementAt(0).timeline
    }. Check out now!';
    widget.forwardController.notificationIcon = allHackathons.elementAt(0).url;
    return allHackathons;
  }

  @override
  void initState() {
    super.initState();
    widget.forwardController.hackathonsReload = _refreshHackathons;
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
                  return HackathonCard(hackathonDocument: currentDocument);
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
  const HackathonCard({required this.hackathonDocument, Key? key}) : super(key: key);
  final HackathonDocument hackathonDocument;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HackathonCardState();
}

class _HackathonCardState extends ConsumerState<HackathonCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      width: 400,
      height: 330,
      child: Card(
        elevation: 3,
        color: const Color.fromARGB(255, 58, 86, 127),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          children: [
            Image.network(
              widget.hackathonDocument.image,
              fit: BoxFit.cover,
              height: 180,
              width: double.infinity,
              errorBuilder: (context, child, error) {
                return const Center(
                  child: Icon(
                    Icons.warning,
                    color: Colors.orangeAccent,
                    size: 45,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                widget.hackathonDocument.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Electrolize',
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                widget.hackathonDocument.timeline.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.hackathonDocument.mode.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  if (widget.hackathonDocument.participants != null) const Padding(
                    padding: EdgeInsets.only(left: 10, right: 2),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  if (widget.hackathonDocument.participants != null) Text(
                    widget.hackathonDocument.participants!.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ElevatedButton(
                onPressed: () => showWebView(context: context, url: widget.hackathonDocument.url), 
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    'Redirect',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

void showWebView({required BuildContext context, required String url}) {
  if (Platform.isAndroid || Platform.isIOS) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomWebView(url: url)
      ),
    );
  }
}

class CustomWebView extends StatefulWidget {
  const CustomWebView({required this.url, Key? key}) : super(key: key);
  final String url;

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  double progress = 0;
  late final WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          await _webViewController.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 58, 78, 122),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
              size: 30,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await _webViewController.canGoBack() ? await _webViewController.goBack() : Navigator.of(context).pop();
              }, 
              icon: const Icon(
                CupertinoIcons.back,
                size: 30,
              )
            ),
            IconButton(
              onPressed: () => _webViewController.reload(), 
              icon: const Icon(
                Icons.refresh,
                size: 30,
              )
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color.fromARGB(255, 58, 78, 122),
                color: progress < 1.0 ? Colors.white : const Color.fromARGB(255, 58, 78, 122),
                minHeight: 3,
              ),
              Expanded(
                child: WebView(
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onProgress: (progress) => setState(() => this.progress = progress/100),
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'barrel.dart';
import 'package:hack_heap/hackathons.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hack Heap',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse, 
          PointerDeviceKind.invertedStylus,
          PointerDeviceKind.stylus, 
          PointerDeviceKind.touch,
          PointerDeviceKind.trackpad, 
          PointerDeviceKind.unknown
        }
      ),
      home: const HackathonsPage(),
    );  
  }
}
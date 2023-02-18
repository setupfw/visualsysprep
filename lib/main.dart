import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AppStatePage {
  firstPage,
  basicPage,
  advancedPage,
  applyingPage,
  resultPage
}

class AppStateModel extends ChangeNotifier {
  var _page = AppStatePage.firstPage;

  AppStatePage get page => _page;

  AppStatePage? get nextPage {
    switch (page) {
      case AppStatePage.firstPage:
        return AppStatePage.basicPage;
      case AppStatePage.basicPage:
        return AppStatePage.advancedPage;
      case AppStatePage.advancedPage:
        return AppStatePage.applyingPage;
      case AppStatePage.applyingPage:
        return AppStatePage.resultPage;
      default:
        return null;
    }
  }

  AppStatePage? get previousPage {
    switch (page) {
      case AppStatePage.advancedPage:
        return AppStatePage.basicPage;
      case AppStatePage.basicPage:
        return AppStatePage.firstPage;
      default:
        return null;
    }
  }

  bool gotoNextPage() {
    final nextPage = this.nextPage;
    if (nextPage == null) return false;

    _page = nextPage;
    notifyListeners();
    return true;
  }

  bool gotoPreviousPage() {
    final previousPage = this.previousPage;
    if (previousPage == null) return false;

    _page = previousPage;
    notifyListeners();
    return true;
  }
}

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AppStateModel()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Consumer<AppStateModel>(builder: (_, appState, __) {
            return Text('${appState.page}');
          }),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [],
          ),
        ),
        bottomNavigationBar: Consumer<AppStateModel>(
            builder: (_, appState, __) => Container(
                  color: Colors.blueAccent,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    height: 64,
                    child: Row(children: [
                      const Spacer(),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('返回'),
                        onPressed: (appState.previousPage != null
                            ? () {
                                appState.gotoPreviousPage();
                              }
                            : null),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            fixedSize: const Size(128, 111)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('前进'),
                        onPressed: (appState.nextPage != null
                            ? () {
                                appState.gotoNextPage();
                              }
                            : null),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            fixedSize: const Size(128, 111)),
                      )
                    ]),
                  ),
                )),
      ),
    );
  }
}

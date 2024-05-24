import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tractian_challenge/components/companyButton.dart';
import 'package:tractian_challenge/models/company.dart';
import 'package:tractian_challenge/providers/homeScreenProvider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Chama fetchCompanies quando o widget for inicializado
    ref.read(homeScreenProvider).fetchCompanies();
  }

  @override
  Widget build(BuildContext context) {
    final homeScreenModel = ref.watch(homeScreenProvider);
    List<Company> companiesList = homeScreenModel.value.companiesList;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(23, 25, 45, 1),
            centerTitle: true,
            title: const Text(
              "TRACTIAN",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: SafeArea(
            child: SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  companiesList.isNotEmpty
                      ? Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              return CompanyButton(
                                name: "${companiesList[index].name} Unit",
                                constraints: constraints,
                                onTap: () => GoRouter.of(context).push('/assets/${companiesList[index].id}'),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 30);
                            },
                            itemCount: companiesList.length,
                          ),
                        )
                      : const Column(
                          children: [
                            SizedBox(height: 100),
                            CircularProgressIndicator(
                              color: Color.fromRGBO(23, 25, 45, 1),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

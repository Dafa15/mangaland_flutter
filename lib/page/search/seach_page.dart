import 'package:flutter/material.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/page/detail/detail_page.dart';
import 'package:mangaland_flutter/page/search/search_view_model.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<SearchViewModel>(context, listen: false).deleteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorConstant.colorPrimary),
        centerTitle: true,
        title: Text(
          "Search Manga",
          style: TextStyleConstant.header1,
        ),
        backgroundColor: ColorConstant.bgColor,
      ),
      backgroundColor: ColorConstant.bgColor,
      body: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) {
          return Column(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                onSubmitted: (value) async {
                  viewModel.getSearchList(value);
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        viewModel.getSearchList(searchController.text);
                      },
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    fillColor: ColorConstant.colorPrimary,
                    filled: true,
                    hintText: "Input manga title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    )),
              ),
            ),
            viewModel.isLoading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : viewModel.listManga.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            "Manga is empty",
                            style: TextStyleConstant.header2,
                          ),
                        ),
                      )
                    : Expanded(
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16.0,
                                    mainAxisSpacing: 16.0,
                                    mainAxisExtent: 281),
                            itemCount: viewModel.listManga.length,
                            padding: const EdgeInsets.all(16),
                            itemBuilder: (context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                          mangaId:
                                              viewModel.listManga[index].id),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 250,
                                      child: Image.network(
                                        "https://uploads.mangadex.org/covers/${viewModel.listManga[index].id}/${viewModel.listManga[index].coverArt!.filename}",
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const SizedBox(
                                            width: double.maxFinite,
                                            height: double.infinity,
                                            child: Center(
                                              child:
                                                  Text("Failed to load image"),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      viewModel.listManga[index].title,
                                      style: TextStyleConstant.header2,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            }))
          ]);
        },
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/model/manga.dart';
import 'package:mangaland_flutter/page/detail/detail_page.dart';
import 'package:mangaland_flutter/page/home/home_page.dart';
import 'package:shimmer/shimmer.dart';

class ListViewCustom extends StatefulWidget {
  final List<Manga> mangaList;
  final String listName;
  const ListViewCustom({super.key, required this.mangaList, required this.listName});

  @override
  State<ListViewCustom> createState() => _ListViewCustomState();
}

class _ListViewCustomState extends State<ListViewCustom> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.listName,
                style: TextStyleConstant.header1,
              ),
              TextButton(
                child: Text(
                  'See more',
                  style: TextStyleConstant.p1,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => const HomePage(index: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.mangaList.length,
            itemBuilder: (context, index) {
              final manga = widget.mangaList[index];
              return _buildMangaCard(context, manga);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMangaCard(BuildContext context, Manga manga) {
    final imgUrl = "https://uploads.mangadex.org/covers/${manga.id}/${manga.coverArt!.filename}";
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(mangaId: manga.id),
            ),
          );
        },
        child: SizedBox(
          width: 120,
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: imgUrl,
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) {
                  return const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  );
                },
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      color: Colors.grey,
                      height: 170,
                      width: 120,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                manga.title,
                style: TextStyleConstant.p2,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}
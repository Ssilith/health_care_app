import 'package:flutter/material.dart';
import 'package:health_care_app/global.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigateToContainer extends StatelessWidget {
  final IconData icon;
  final String title;
  final String mess;
  final String? url;
  final bool isOnTap;
  const NavigateToContainer(
      {super.key,
      required this.icon,
      required this.title,
      required this.mess,
      this.url,
      this.isOnTap = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(23, 202, 202, 202),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 38.0,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 3),
                VerticalDivider(
                  thickness: 1,
                  color: Theme.of(context).primaryColor,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.normal),
                      ),
                      Expanded(
                        child: Text(
                          mess,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isOnTap)
                  IconButton(
                    onPressed: isOnTap
                        ? () async {
                            if (url != null) _launchUrl(url!);
                          }
                        : null,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                if (title == 'Name')
                  IconButton(
                      onPressed: () => copyToClipboard(mess),
                      icon: Icon(Icons.copy,
                          color: Theme.of(context).primaryColor))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchUrl(String url) async {
    Uri urlAddress = Uri.parse(url);
    if (!await launchUrl(urlAddress)) {
      throw Exception('Nie można połączyć z $urlAddress');
    }
  }
}

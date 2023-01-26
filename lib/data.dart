class DownloadItems {
  static const documents = [
    DownloadItem(
      name: '03_01',
      url: 'http://10.1.1.231/site/03_01.mp3',
    ),
    DownloadItem(
      name: '01_02',
      url: 'http://10.1.1.231/site/01_02.mp3',
    ),
  ];
}

class DownloadItem {
  const DownloadItem({required this.name, required this.url});

  final String name;
  final String url;
}

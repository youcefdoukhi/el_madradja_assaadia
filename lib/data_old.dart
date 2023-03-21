class DownloadItems {
  static const book01 = [
    DownloadItem(
      name: '01_01',
      url: 'http://10.1.1.19/site/01_01.mp3',
    ),
  ];

  static const book02 = [
    DownloadItem(
      name: '02_01',
      url: 'http://10.1.1.19/site/02_01.mp3',
    ),
  ];
  static const book03 = [
    DownloadItem(
      name: '03_01',
      url: 'http://10.1.1.19/site/03_01.mp3',
    ),
  ];
}

class DownloadItem {
  const DownloadItem({required this.name, required this.url});

  final String name;
  final String url;
}

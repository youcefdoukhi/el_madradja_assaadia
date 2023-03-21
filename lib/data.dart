class DownloadItems {
  static const book01 = [
    DownloadItem(
      name: '01_01',
      url: 'http://10.1.1.19/el_madradja/01/01.mp3',
    ),
    DownloadItem(
      name: '01_02',
      url: 'http://10.1.1.19/el_madradja/01/02.mp3',
    ),
  ];

  static const book02 = [
    DownloadItem(
      name: '02_01',
      url: 'http://10.1.1.19/el_madradja/02/01.mp3',
    ),
  ];
  static const book03 = [
    DownloadItem(
      name: '03_01',
      url: 'http://10.1.1.19/el_madradja/03/01.mp3',
    ),
  ];
  static const book04 = [
    DownloadItem(
      name: '04_01',
      url: 'http://10.1.1.19/el_madradja/04/01.mp3',
    ),
  ];
  static const book05 = [
    DownloadItem(
      name: '05_01',
      url: 'http://10.1.1.19/el_madradja/05/01.mp3',
    ),
  ];
}

class DownloadItem {
  const DownloadItem({required this.name, required this.url});

  final String name;
  final String url;
}

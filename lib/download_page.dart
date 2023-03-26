import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'data.dart';
import 'download_list_item.dart';

class MyDownloadPage extends StatefulWidget with WidgetsBindingObserver {
  const MyDownloadPage({super.key, required this.platform});

  final TargetPlatform? platform;

  @override
  MyDownloadPageState createState() => MyDownloadPageState();
}

class MyDownloadPageState extends State<MyDownloadPage> {
  List<TaskInfo>? _tasks;
  late List<ItemHolder> _items;
  late bool _showContent;
  late String _localPath;
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback, step: 1);

    _showContent = false;

    _prepare();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = DownloadTaskStatus(data[1] as int);
      final progress = data[2] as int;

      if (_tasks != null && _tasks!.isNotEmpty) {
        final task = _tasks!.firstWhere((task) => task.taskId == taskId);
        setState(() {
          task
            ..status = status
            ..progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status.value, progress]);
  }

  Widget _buildDownloadList() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        ..._items.map(
          (item) {
            final task = item.task;
            if (task == null) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  item.name!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 18,
                  ),
                ),
              );
            }

            return DownloadListItem(
              data: item,
              onTap: (task) async {
                final success = await _openDownloadedFile(task);
                if (!success) {}
              },
              onActionTap: (task) {
                if (task.status == DownloadTaskStatus.undefined) {
                  _requestDownload(task);
                } else if (task.status == DownloadTaskStatus.running) {
                  _pauseDownload(task);
                } else if (task.status == DownloadTaskStatus.paused) {
                  _resumeDownload(task);
                } else if (task.status == DownloadTaskStatus.complete ||
                    task.status == DownloadTaskStatus.canceled) {
                  _delete(task);
                } else if (task.status == DownloadTaskStatus.failed) {
                  _retryDownload(task);
                }
              },
              onCancel: _delete,
            );
          },
        ),
      ],
    );
  }

  Future<void> _requestDownload(TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
      url: task.link!,
      headers: {},
      savedDir: _localPath,
      showNotification: false,
      openFileFromNotification: false,
    );
  }

  Future<void> _pauseDownload(TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId!);
  }

  Future<void> _resumeDownload(TaskInfo task) async {
    final newTaskId = await FlutterDownloader.resume(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  Future<void> _retryDownload(TaskInfo task) async {
    final newTaskId = await FlutterDownloader.retry(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(TaskInfo? task) async {
    final taskId = task?.taskId;
    if (taskId == null) {
      return false;
    }

    return FlutterDownloader.open(taskId: taskId);
  }

  Future<void> _delete(TaskInfo task) async {
    final mytask = FlutterDownloader.loadTasksWithRawQuery(
      query: 'SELECT file_name FROM task WHERE taskId=${task.taskId}',
    );
    // await entity.exists();
    print("----------  : $mytask");
    await FlutterDownloader.remove(
      taskId: task.taskId!,
      shouldDeleteContent: false,
    );

    //await File("").delete();
    await _prepare();
    setState(() {});
  }

  Future<void> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    if (tasks == null) {
      return;
    }

    var count = 0;
    _tasks = [];
    _items = [];

    _tasks!.addAll(
      DownloadItems.book01.map(
        (darss) => TaskInfo(name: darss.name, link: darss.url),
      ),
    );

    _items.add(ItemHolder(name: 'منهج السالكين'));
    for (var i = count; i < _tasks!.length; i++) {
      _items.add(ItemHolder(name: _tasks![i].name, task: _tasks![i]));
      count++;
    }

    _tasks!.addAll(
      DownloadItems.book02
          .map((darss) => TaskInfo(name: darss.name, link: darss.url)),
    );

    _items.add(ItemHolder(name: 'منظومة القواعد الفقهية'));
    for (var i = count; i < _tasks!.length; i++) {
      _items.add(ItemHolder(name: _tasks![i].name, task: _tasks![i]));
      count++;
    }

    _tasks!.addAll(
      DownloadItems.book03
          .map((darss) => TaskInfo(name: darss.name, link: darss.url)),
    );

    _items.add(ItemHolder(name: 'رسالة لطيفة في أصول الفقه'));
    for (var i = count; i < _tasks!.length; i++) {
      _items.add(ItemHolder(name: _tasks![i].name, task: _tasks![i]));
      count++;
    }

    _tasks!.addAll(
      DownloadItems.book04
          .map((darss) => TaskInfo(name: darss.name, link: darss.url)),
    );

    _items.add(ItemHolder(name: 'الإرشاد إلى معرفة الأحكام'));
    for (var i = count; i < _tasks!.length; i++) {
      _items.add(ItemHolder(name: _tasks![i].name, task: _tasks![i]));
      count++;
    }

    for (final task in tasks) {
      for (final info in _tasks!) {
        if (info.link == task.url) {
          info
            ..taskId = task.taskId
            ..status = task.status
            ..progress = task.progress;
        }
      }
    }

    await _prepareSaveDir();
    setState(() {
      _showContent = true;
    });
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _getSavedDir())!;
    final savedDir = Directory("$_localPath/MP3");
    if (!savedDir.existsSync()) {
      await savedDir.create();
    }
  }

  Future<String?> _getSavedDir() async {
    String? storageDirPath;

    if (Platform.isAndroid) {
      try {
        storageDirPath =
            (await getApplicationDocumentsDirectory()).absolute.path;
      } catch (err) {
        return null;
      }
    } else if (Platform.isIOS) {
      storageDirPath = (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return storageDirPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download"),
        actions: [
          if (Platform.isIOS)
            PopupMenuButton<Function>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => exit(0),
                  child: const ListTile(
                    title: Text(
                      'Simulate App Backgrounded',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
      body: Builder(
        builder: (context) {
          if (!_showContent) {
            return const Center(child: CircularProgressIndicator());
          }

          return _buildDownloadList();
        },
      ),
    );
  }
}

class ItemHolder {
  ItemHolder({this.name, this.task});

  final String? name;
  final TaskInfo? task;
}

class TaskInfo {
  TaskInfo({this.name, this.link});

  final String? name;
  final String? link;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;
}

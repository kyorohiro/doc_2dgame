part of tinygame_flutter;

class TinyFlutterFile extends TinyFile {
  File f;
  TinyFlutterFile(this.f) {
  }

  init() async {
    if(await f.exists() == false) {
      await f.create(recursive: true);
    }
  }

  Future<int> write(List<int> buffer, int offset) async {
    await init();
    RandomAccessFile af = await f.open(mode: FileMode.WRITE);
    await af.setPosition(offset);
    await af.writeFrom(buffer);
    await af.close();
    return buffer.length;
  }

  Future<List<int>> read(int offset, int length) async {
    await init();
    RandomAccessFile af = await f.open();
    await af.setPosition(offset);
    List<int> ret = await af.read(length);
    await af.close();
    return ret;
  }

  Future<int> getLength() async {
    await init();
    return f.length();
  }

  Future<int> truncate(int fileSize) async {
    await init();
    int s = await getLength();
    if(fileSize >= s) {
      return s;
    }
    RandomAccessFile af = await f.open();
    await af.truncate(fileSize);
    int ret = await getLength();
    await af.close();
    return ret;
  }
}

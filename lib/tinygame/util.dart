part of tinygame;

//https://en.wikipedia.org/wiki/Jenkins_hash_function
//http://pchalin.blogspot.jp/2014/04/defining-equality-and-hashcode-for-dart.html
class JenkinsHash {
  static int calc(List<int> vs) {
    int v1 = 0;
    for (int v2 in vs) {
      v1 += v2;
      v1 += v1 << 10;
      v1 ^= (v1 >> 6);
    }
    v1 += v1 << 3;
    v1 ^= v1 >> 11;
    v1 += v1 << 15;

    return v1;
  }
}

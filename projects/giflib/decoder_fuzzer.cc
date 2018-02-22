#include <fstream>
#include <memory>
#include <sstream>
#include <string>
#include <unistd.h>

#include <gif_lib.h>

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
  static const std::string filename = "temp.gif";
  std::ofstream file(filename, std::ios::binary | std::ios::out | std::ios::trunc);
  if (!file.is_open()) {
    return 0;
  }
  file.write(reinterpret_cast<const char *>(data), size);
  file.close();

  GifFileType *gif = DGifOpenFileName(filename.c_str(), NULL);
  if (gif == NULL) {
    unlink(filename.c_str());
    return 0;
  }

  DGifSlurp(gif);
  DGifCloseFile(gif, NULL);

  unlink(filename.c_str());
  return 0;
}

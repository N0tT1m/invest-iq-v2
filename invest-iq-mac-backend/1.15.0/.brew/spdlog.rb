class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "9962648c9b4f1a7bbc76fd8d9172555bad1871fdb14ff4f842ef87949682caa5"
  license "MIT"
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  depends_on "cmake" => :build
  depends_on "fmt"

  # error: specialization of 'template<class T, ...> struct fmt::v8::formatter' in different namespace
  fails_with gcc: "5"

  def install
    ENV.cxx11

    inreplace "include/spdlog/tweakme.h", "// #define SPDLOG_FMT_EXTERNAL", <<~EOS
      #ifndef SPDLOG_FMT_EXTERNAL
      #define SPDLOG_FMT_EXTERNAL
      #endif
    EOS

    args = std_cmake_args + %W[
      -Dpkg_config_libdir=#{lib}
      -DSPDLOG_BUILD_BENCH=OFF
      -DSPDLOG_BUILD_EXAMPLE=OFF
      -DSPDLOG_BUILD_TESTS=OFF
      -DSPDLOG_FMT_EXTERNAL=ON
    ]
    system "cmake", "-S", ".", "-B", "build", "-DSPDLOG_BUILD_SHARED=ON", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build", "-DSPDLOG_BUILD_SHARED=OFF", *args
    system "cmake", "--build", "build"
    lib.install "build/libspdlog.a"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "spdlog/sinks/basic_file_sink.h"
      #include <iostream>
      #include <memory>
      int main()
      {
        try {
          auto console = spdlog::basic_logger_mt("basic_logger", "#{testpath}/basic-log.txt");
          console->info("Test");
        }
        catch (const spdlog::spdlog_ex &ex)
        {
          std::cout << "Log init failed: " << ex.what() << std::endl;
          return 1;
        }
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{Formula["fmt"].opt_lib}", "-lfmt", "-o", "test"
    system "./test"
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end

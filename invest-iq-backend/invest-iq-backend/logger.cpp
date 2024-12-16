#include <iostream>
#include <fstream>
#include "spdlog/spdlog.h"
using namespace std;

namespace Logger {
	class FileLogger {
		public:
			FileLogger() = default;
			FileLogger(std::string file_name) : file_name{file_name} {
				cout << file_name;
			};

			~FileLogger() {
				file_name.clear();
			};

			void LogInfo(std::string) {
				try
				{
					auto logger = spdlog::basic_logger_mt("basic_logger", "logs/basic-log.txt");
				}
				catch (const spdlog::spdlog_ex& ex)
				{
					std::cout << "Log init failed: " << ex.what() << std::endl;
				}
			}

		private:
			std::string file_name;
	};
}
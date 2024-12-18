#include <iostream>
#include <fstream>
#include "spdlog/spdlog.h"
#include "spdlog/sinks/basic_file_sink.h" // support for basic file logging
#include "spdlog/sinks/rotating_file_sink.h" // support for rotating file logging

using namespace std;

namespace Logger {
	class FileLogger {
		public:
			FileLogger() = default;
			FileLogger(std::string logger_name) : logger_name{ logger_name} {
				cout << logger_name;
			};

			~FileLogger() {
				logger_name.clear();
			};

			void Log(std::string msg, spdlog::level::level_enum level) {
				try
				{
					auto logger = spdlog::basic_logger_mt(logger_name, "logs/trading-log.txt");
					logger->log(level, msg);
				}
				catch (const spdlog::spdlog_ex& ex)
				{
					std::cout << "Log init failed: " << ex.what() << std::endl;
				}
			}

		private:
			std::string logger_name;
	};
}
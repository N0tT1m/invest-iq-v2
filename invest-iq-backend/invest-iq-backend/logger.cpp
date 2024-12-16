#include <iostream>
#include <fstream>
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
				std::ofstream outputFile(file_name);

				if (outputFile.is_open()) {

				}
			}

		private:
			std::string file_name;
	};
}
#include <iostream>
#include <thread>
#include <chrono>
#include <string>
#include <optional>
#include <variant>
#include <sys/select.h>

#include "discord.h"

discord::Core *core{};

constexpr long client_id = 998703402257240084;

enum Command {
	Invalid,
	State,
	Details,
	Start,
	End,
	LargeImage,
	LargeText,
	SmallImage,
	SmallText
};

using command_t = std::pair<Command, std::variant<std::monostate, long, std::string>>;
command_t parse_command(const std::string &command) {
	const command_t INVALID = { Invalid, std::monostate() };

	size_t colon;
	if((colon = command.find(':')) == std::string::npos) return INVALID;

	std::string name = command.substr(0, colon);
	std::string value = command.substr(colon+1);

	if(name.empty() || value.empty()) return INVALID;

	const std::unordered_map<std::string, Command> pattern = {
		{ "state", State },
		{ "details", Details },
		{ "start", Start },
		{ "end", End },
		{ "large_image", LargeImage },
		{ "large_text", LargeText },
		{ "small_image", SmallImage },
		{ "small_text", SmallText },
	};

	try {
		Command command = pattern.at(name);
		command_t::second_type out = std::monostate();

		switch(command) {
		case Start:
		case End:
			out = std::stol(value);
			break;
		default:
			out = value;
			break;
		}

		return { command, out };
	}
	catch(std::out_of_range &e) {
		std::cerr << "invalid commmand: " << name << "\n";

		return INVALID;
	}
	catch(std::invalid_argument &e) {
		std::cerr << "invalid numbed given for timestamp: " << value << "\n";

		return INVALID;
	}
}

int main(int, char **) {
	auto result = discord::Core::Create(client_id, DiscordCreateFlags_NoRequireDiscord, &core);

	if(result != discord::Result::Ok) return -1;

	auto activity = discord::Activity();

	auto activity_callback = [](discord::Result result) -> void {
		if(result != discord::Result::Ok)
			std::cerr << "error setting activity: " << (int)result << "\n";
	};

	// core->ActivityManager().UpdateActivity(activity, activity_callback);

	// core->ImageManager().Fetch

	// timeval tv = { 0L, 0L };
	// fd_set fds;
	// FD_ZERO(&fds);
	// FD_SET(0, &fds); // stdin

	std::string line;
	while(true) {

		core->RunCallbacks();
		// Poll stdin
		// int ready = select(0 + 1, &fds, NULL, NULL, &tv);

		// while(ready > 0) {
			std::getline(std::cin, line);

			if(line == "quit") break;

			auto [ command, value ] = parse_command(line);

			switch(command) {
			case Invalid:
				goto skip;
			case State:
				activity.SetState(std::get<std::string>(value).c_str());
				break;
			case Details:
				activity.SetDetails(std::get<std::string>(value).c_str());
				break;
			case LargeImage:
				activity.GetAssets().SetLargeImage(std::get<std::string>(value).c_str());
				break;
			case LargeText:
				activity.GetAssets().SetLargeText(std::get<std::string>(value).c_str());
				break;
			case SmallImage:
				activity.GetAssets().SetSmallImage(std::get<std::string>(value).c_str());
				break;
			case SmallText:
				activity.GetAssets().SetSmallText(std::get<std::string>(value).c_str());
				break;
			case Start:
				activity.GetTimestamps().SetStart(std::get<long>(value));
				break;
			case End:
				activity.GetTimestamps().SetEnd(std::get<long>(value));
				break;
			}

			core->ActivityManager().UpdateActivity(activity, activity_callback);

		skip:
			// ready = select(0 + 1, &fds, NULL, NULL, &tv);
		;
		// }

		// using namespace std::chrono_literals;

		// std::this_thread::sleep_for(1s);
	}

core->ActivityManager().ClearActivity(nullptr);

	return 0;
}

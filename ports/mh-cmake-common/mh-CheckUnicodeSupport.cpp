#define _SILENCE_CXX20_CODECVT_FACETS_DEPRECATION_WARNING

#include <filesystem>
#include <fstream>
#include <string>

template<typename CharT, typename Traits = std::char_traits<CharT>, typename Alloc = std::allocator<CharT>>
std::basic_string<CharT, Traits, Alloc> TestFunc(const std::filesystem::path& path)
{
	std::basic_ifstream<CharT, Traits> file;
	file.open(path);

	file.seekg(0, std::ios::end);
	const auto length = file.tellg();
	file.seekg(0);

	std::basic_string<CharT, Traits, Alloc> retVal(static_cast<size_t>(length), ' ');
	file.read(retVal.data(), length);

	return retVal;
}

int main([[maybe_unused]] int argc, [[maybe_unused]] char** argv)
{
	TestFunc<char16_t>("hello_char16");
	TestFunc<char32_t>("hello_char32");
}

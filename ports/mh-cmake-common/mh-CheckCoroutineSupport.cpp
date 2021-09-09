
#if __has_include(<coroutine>)
#include <coroutine>
#define MH_COROUTINES_SUPPORTED 1
namespace mh::detail
{
	namespace coro = std;
}
#elif __has_include(<experimental/coroutine>)
#define MH_COROUTINES_SUPPORTED 1
namespace mh::detail
{
	namespace coro = std::experimental;
}
#endif

int main([[maybe_unused]] int argc, [[maybe_unused]] char** argv)
{
	[[maybe_unused]] mh::detail::coro::coroutine_handle<> handle;
	return 0;
}

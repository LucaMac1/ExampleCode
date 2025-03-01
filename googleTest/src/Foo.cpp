#include "Foo.h"

int Foo::fooInt(const std::string &str)
{
	return str.size();
}

void Foo::fooStr(std::string &str)
{
	str = "ExampleStr";
}

void Foo::fooThrow()
{
	throw std::runtime_error("ERROR_TEST");
}

void Foo::callbackMethod(const std::function<void()>& callback)
{
	callback();
}
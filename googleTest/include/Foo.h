#pragma once

#include "IFoo.h"
#include <string>
#include <functional>

class Foo : public IFoo
{
public:
	int fooInt(const std::string &str) override;
	void fooStr(std::string &str) override;
	void fooThrow() override;
	void callbackMethod(const std::function<void()>& callback) override;
};
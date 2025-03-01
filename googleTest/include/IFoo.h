#pragma once

#include <iostream>
#include <functional>

class IFoo
{
public:
	virtual ~IFoo() = default;  // Always provide a virtual destructor in an interface
	virtual int fooInt(const std::string &str) = 0;
	virtual void fooStr(std::string &str) = 0;
	virtual void fooThrow() = 0;
	virtual void callbackMethod(const std::function<void()>& callback) = 0;
};


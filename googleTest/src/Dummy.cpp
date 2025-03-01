#include "Dummy.h" 

int Dummy::dummyInt(const std::string& str) 
{
	return mIfoo.fooInt(str); 
}

void Dummy::dummyStr(std::string& str) 
{
	mIfoo.fooStr(str); 
}

void Dummy::dummyThrow()
{
	mIfoo.fooThrow(); 
}

void Dummy::dummyCallback(const std::function<void()>& callback) 
{
	mIfoo.callbackMethod(callback); 
}
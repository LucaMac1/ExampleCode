#pragma once

#include <iostream>
#include <string>
#include <functional>
#include "IFoo.h"

class Dummy {
	public:
		Dummy(IFoo &f) : mIfoo(f) {}
	
		int dummyInt(const std::string& str); 
		void dummyStr(std::string& str); 
		void dummyThrow();                     
		void dummyCallback(const std::function<void()>& callback); 
	
	private:
		IFoo &mIfoo; 
};
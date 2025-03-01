#include "IFoo.h"
#include <gmock/gmock.h>
#include <string>
#include <functional>

class MockFoo : public IFoo
{
public:
    MOCK_METHOD(int, fooInt, (const std::string& str), (override));
    MOCK_METHOD(void, fooStr, (std::string& str), (override));
    MOCK_METHOD(void, fooThrow, (), (override));
    MOCK_METHOD(void, callbackMethod, (const std::function<void()>&), (override));
};

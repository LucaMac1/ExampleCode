#include <iostream>
#include <gtest/gtest.h>
#include <gmock/gmock.h>

#include "Dummy.h"
#include "IFoo.h"
#include "Foo.h"
#include "MockFoo.h"

class DummyTest : public testing::Test
{
protected:
    void SetUp() override
    {
        // Initialization code executed before each test
        // std::cout << "dummyTestObj is null " << (dummyTestObj == nullptr) << std::endl;
        dummyTestObj = std::make_unique<Dummy>(mMockFoo);
    }

    void TearDown() override
    {
        // Code here will execute just after each test completes
    }

    MockFoo mMockFoo;                    // Corrected the type to MockFoo
    std::unique_ptr<Dummy> dummyTestObj; // Dummy object under test
};

TEST_F(DummyTest, TestDummyInt)
{
    std::string testString{"testString"};
    EXPECT_CALL(mMockFoo, fooInt(testing::_)).Times(1).WillOnce(testing::Return(testString.size()));

    int result = dummyTestObj->dummyInt(testString);
    ASSERT_EQ(result, testString.size());
}

TEST_F(DummyTest, TestDummyStr)
{
    std::string testString;
    std::string returnStr{"testString"};
    EXPECT_CALL(mMockFoo, fooStr(testing::_)).WillOnce(testing::SetArgReferee<0>(returnStr));

    dummyTestObj->dummyStr(testString);
    ASSERT_EQ(testString, returnStr);
}

TEST_F(DummyTest, UnitTest2)
{
    ASSERT_EQ(1, 1);
}

// ACTION(throwError)
// {
//     std::cout << "ERROR!\n";
//     throw std::runtime_error("ERROR_TEST");
// }

TEST_F(DummyTest, ThrowTest)
{
    // EXPECT_CALL(mMockFoo, fooThrow()).WillOnce(throwError());
    // ASSERT_THROW(dummyTestObj->dummyThrow(), std::runtime_error);

    EXPECT_CALL(mMockFoo, fooThrow()).WillOnce([]() { 
        std::cout << "ERROR!\n";
        throw std::runtime_error("ERROR_TEST"); });
    EXPECT_THROW(dummyTestObj->dummyThrow(), std::runtime_error);
}

void throwFunction()
{
    std::cout << "ERROR!\n";
    throw std::runtime_error("ERROR_TEST");
}

TEST_F(DummyTest, ThrowTest2)
{
    EXPECT_CALL(mMockFoo, fooThrow()).WillOnce(testing::Throw(std::runtime_error("ERROR_TEST")));
    ASSERT_THROW(dummyTestObj->dummyThrow(), std::runtime_error);

    EXPECT_CALL(mMockFoo, fooThrow()).WillOnce(testing::Invoke([]()
                                                               {
        std::cout << "ERROR!\n";
        throw std::runtime_error("ERROR_TEST"); }));

    ASSERT_THROW(dummyTestObj->dummyThrow(), std::runtime_error);

    EXPECT_CALL(mMockFoo, fooThrow()).WillOnce(testing::Invoke(throwFunction));
    ASSERT_THROW(dummyTestObj->dummyThrow(), std::runtime_error);
}

TEST_F(DummyTest, TestCallback)
{
    testing::MockFunction<void(void)> testFunc;

    // Ensure callbackMethod is called and invokes the provided callback function
    EXPECT_CALL(mMockFoo, callbackMethod(testing::_)).Times(1).WillOnce(testing::InvokeArgument<0>());

    EXPECT_CALL(testFunc, Call());

    dummyTestObj->dummyCallback(testFunc.AsStdFunction());
}

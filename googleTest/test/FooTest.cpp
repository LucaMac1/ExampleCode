#include <iostream>
#include <gtest/gtest.h>
#include <gmock/gmock.h>

#include "Foo.h"

class FooTest : public testing::Test { 
protected: 
   void SetUp() override { 
       // std::cout << "fooTestObj is null: " << (fooTestObj == nullptr) << std::endl;
       fooTestObj = std::make_unique<Foo>();
   }

   void TearDown() override { 
   }

   std::unique_ptr<Foo> fooTestObj;
};


TEST_F(FooTest, TestFooInt) { 
    std::string testString {"testString"};

    int result = fooTestObj->fooInt(testString);
    ASSERT_EQ(result, testString.size());
}

TEST_F(FooTest, TestDummyStr) { 
    std::string testString;
    std::string returnStr {"ExampleStr"};

    fooTestObj->fooStr(testString);
    ASSERT_EQ(testString, returnStr);
}

TEST_F(FooTest, ThrowTest) { 
    ASSERT_THROW(fooTestObj->fooThrow(), std::runtime_error);
}

TEST_F(FooTest, TestCallback) { 
    testing::MockFunction<void(void)> testFunc;

    // Ensure callbackMethod is called and invokes the provided callback function
    EXPECT_CALL(testFunc, Call());

    fooTestObj->callbackMethod(testFunc.AsStdFunction());
}

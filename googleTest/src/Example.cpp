#include <iostream>
#include <gtest/gtest.h>

using namespace std;

class Example
{
	public:
		int foo()
		{
			return 1;
		}
};

class ExampleFixture : public testing::Test 
{
	public:
		ExampleFixture() : testExPtr(nullptr) {} 
		// Set testExPtr to nullptr after deallocation to avoid potential dangling pointer access.
		
		// Moved initialization to SetUp
		void SetUp() override {
			testExPtr = new Example();
		}

		// Moved deallocation to TearDown
		void TearDown() override {
			delete testExPtr;
			testExPtr = nullptr;
		}

		Example* testExPtr;
};

TEST_F(ExampleFixture, test1)
{
	ASSERT_EQ(1, testExPtr->foo());
}

TEST_F(ExampleFixture, test2)
{
	ASSERT_NE(0, testExPtr->foo());
}

int main(int argc, char **argv)
{
	testing::InitGoogleTest(&argc, argv);
	return RUN_ALL_TESTS();
}
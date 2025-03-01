
## GoogleTest Introduction with CMake - GMOCK Usage

You can find the video content for an introduction to gtest/gmock. 

[![Youtube video link](https://img.youtube.com/vi/zfgFphZ63UY/0.jpg)](//www.youtube.com/watch?v=zfgFphZ63UY?t=0s "ulas dikme")

### Install GoogleTest and Compile

```bash
$ git clone https://github.com/google/googletest.git -b release-1.12.0
$ cd googletest
$ mkdir build
$ cd build
$ cmake .. -DBUILD_GMOCK=OFF
$ make
```

Please check the current release version and update the git clone command accordingly.

After this, your related static binaries will be in the `googletest/build/lib/` location.

### Writing a Simple GoogleTest Application

To test it, let's write a simple "Hello World" GoogleTest application (you can find it as `Example.cpp` in the repo).

```bash
# cd ..
# mkdir googleTest
# cd googleTest
```

Content of `Example.cpp`:

```cpp
#include <iostream>
#include <gtest/gtest.h>

using namespace std;

TEST(TestName, test1)
{
    ASSERT_EQ(1, 1);
}

int main(int argc, char **argv)
{
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
```

Here, the main method and the test method are named `TestName.test1`. To compile it, you can use:

```bash
g++ Example.cpp ../build/lib/libgtest.a -lpthread -I googletest/googletest/include/
```

After this, it will generate `a.out` when you run it:

```bash
jnano@jnano:~$ ./a.out 
[==========] Running 1 test from 1 test suite.
[----------] Global test environment set-up.
[----------] 1 test from TestName
[ RUN      ] TestName.test1
[       OK ] TestName.test1 (0 ms)
[----------] 1 test from TestName (0 ms total)

[----------] Global test environment tear-down
[==========] 1 test from 1 test suite ran. (0 ms total)
[  PASSED  ] 1 test.
```

### Running Without `main()`

If you want to run it without the `main()` function, you can add `libgtest_main.a`:

```cpp
#include <iostream>
#include <gtest/gtest.h>

using namespace std;

TEST(TestName, test1)
{
    ASSERT_EQ(1, 1);
}
```

To compile:

```bash
g++ Example.cpp ../build/lib/libgtest.a ../build/lib/libgtest_main.a -lpthread -I ../googletest/googletest/include/
```

This will produce the same output. In the video, I used both `libgtest_main` and `libgtest`, which is not exactly correct. 

**Note:** If you use a pre-installed GoogleTest, then `libgtest_main` is named `libgtest_maind` (you can try with the Godbolt compiler).

### Testing a Class Method

If you want to test a method of a class, you need to create an object inside the test or create one global object.

```cpp
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

TEST(TestName, test1)
{
    Example ex;
    ASSERT_EQ(1, ex.foo());
}

TEST(TestName, test2)
{
    Example ex;
    ASSERT_NE(0, ex.foo());
}

int main(int argc, char **argv)
{
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
```

However, these are not ideal solutions, so we need a design or approach that allows us to keep all objects under test within a single class. We can achieve this with test fixtures:

### Using Test Fixtures

```cpp
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
        ExampleFixture() : exampleTestObj(nullptr) {}

        void SetUp() override {
            exampleTestObj = new Example();
        }

        void TearDown() override {
            delete exampleTestObj;
            exampleTestObj = nullptr;
        }

        Example* exampleTestObj;
};

TEST_F(ExampleFixture, test1)
{
    ASSERT_EQ(1, exampleTestObj->foo());
}

TEST_F(ExampleFixture, test2)
{
    ASSERT_NE(0, exampleTestObj->foo());
}

int main(int argc, char **argv)
{
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
```

As you can see, after the `TEST` macro, there is `_F`. Each test case starts with the name of the class that encapsulates the object under test.

### Using CMake for Compilation

We do not use the command line to compile our projects, so it's a good idea to use CMake for compilation. Create a file named `CMakeLists.txt` and copy the content below:

```bash
cmake_minimum_required(VERSION 3.10)
set(CMAKE_CXX_STANDARD 14)

project(ExampleGtest LANGUAGES CXX)

include_directories(../googletest/googletest/include)
add_executable(${PROJECT_NAME} example.cpp)
target_link_libraries(${PROJECT_NAME} ${CMAKE_SOURCE_DIR}/../googletest/build/lib/libgtest.a ${CMAKE_SOURCE_DIR}/../googletest/build/lib/libgtest_main.a)

set(CMAKE_THREAD_LIBS_INIT "-lpthread")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread")
set(CMAKE_HAVE_THREADS_LIBRARY 1)
set(CMAKE_USE_WIN32_THREADS_INIT 0)
set(CMAKE_USE_PTHREADS_INIT 1)
set(THREADS_PREFER_PTHREAD_FLAG ON)
```

This links the static binaries and includes headers using CMake. But is this the best practice? No.

### Using `FetchContent` to Fetch GoogleTest

If you check [this link](https://cmake.org/cmake/help/latest/module/FetchContent.html), you'll see that you can fetch content from the repository directly, without needing to build it yourself.

```bash
cmake_minimum_required(VERSION 3.14)
set(CMAKE_CXX_STANDARD 14)

project(ExampleGtest LANGUAGES CXX)

include(FetchContent)
FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG        bf66935e07825318ae519675d73d0f3e313b3ec6 
)
FetchContent_MakeAvailable(googletest)

add_executable(${PROJECT_NAME} example.cpp)

target_link_libraries(${PROJECT_NAME} gtest_main gmock_main)

include(GoogleTest)
gtest_discover_tests(${PROJECT_NAME})

#include headers
include_directories(include)
```

This will automatically fetch and compile GoogleTest. You can specify the desired commit number, but be careful with the CMake version, as older versions may not support this.

There's one more benefit: `gtest_discover_tests` allows us to remove the `main()` function in `Example.cpp`. This means you don't have to initialize GoogleTest or run it manually—just define the tests.

## GoogleMock Example

What is GoogleMock? When your object has dependencies during unit testing, these dependencies should be mocked. Once mocked, your object does not call the real methods of the dependencies but instead calls the mocked methods.

It's beneficial to use interfaces in your design.

For example, in the code below, the `Foo` class is mocked. If you check under the `include` directory, there is a `MockFoo.h` file (although keeping it with other headers is not a good idea).

```cpp
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
```

As you can see, it implements the `IFoo` interface. The implementation uses the `MOCK_METHOD` macro, which first defines the return type, then the function name, and finally the arguments.

To inject this into your object, use its constructor:

```cpp
dummyTestObj = std::make_unique<Dummy>(mMockFoo);
```

Since we use the same interface, this shows one of the advantages of using interfaces.

In the test fixture, you can use it like:

```cpp
EXPECT_CALL(mMockFoo, fooStr(testing::_)).WillOnce(testing::SetArgReferee<0>(returnStr));
```

This means the `fooStr` method of the mock must be called and return the string from the argument for this test; otherwise, GoogleTest will fail.

For a better understanding of the relationship between mock and test classes, refer to the diagram below (this design is for the simple example, and the relationship may vary depending on your requirements).

![Class Diagram](https://www.plantuml.com/plantuml/proxy?src=https://raw.githubusercontent.com/Physics-publishers/samples/master/uml/uml_gtest_gmock_class.txt)

We use two libraries: `gmock_main` and `gtest_main`. To compile the test code:

```bash
$ g++ example.cpp -lgtest_main -lgmock -lpthread -I ../googletest/googletest/include
```


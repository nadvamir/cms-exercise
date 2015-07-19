# A sample Makefile for building both Google Mock and Google Test and
# using them in user tests.  This file is self-contained, so you don't
# need to use the Makefile in Google Test's source tree.  Please tweak
# it to suit your environment and project.  You may want to move it to
# your project's root directory.
#
# SYNOPSIS:
#
#   make [all]  - makes everything.
#   make TARGET - makes the given target.
#   make clean  - removes all files generated by make.

###### CUSTOMISATION POINT ###################################
# All tests produced by this Makefile.
TESTS = tests.exe
# Where to find user code.
TEST_DIR = test

# name of the executable
MAIN_NAME = cms.exe

# Please tweak the following variable definitions as needed by your
# project, except GMOCK_HEADERS and GTEST_HEADERS, which you can use
# in your own targets but shouldn't modify.

# Points to the root of Google Mock, relative to where this file is.
# Remember to tweak this if you move this file.
GMOCK_DIR = /home/maxx/libraries/google-test/gmock-1.7.0

# Points to the root of Google Test, relative to where this file is.
# Remember to tweak this if you move this file, or if you want to use
# a copy of Google Test at a different location.
GTEST_DIR = $(GMOCK_DIR)/gtest

# Flags passed to the preprocessor.
# Set Google Test and Google Mock's header directories as system
# directories, such that the compiler doesn't generate warnings in
# these headers.
CPPFLAGS += -isystem $(GTEST_DIR)/include -isystem $(GMOCK_DIR)/include -I.

# Flags passed to the C++ compiler.
CXXFLAGS += -g -Wall -Wextra -pthread -I.

# All Google Test headers.  Usually you shouldn't change this
# definition.
GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
                $(GTEST_DIR)/include/gtest/internal/*.h

# All Google Mock headers. Note that all Google Test headers are
# included here too, as they are #included by Google Mock headers.
# Usually you shouldn't change this definition.	
GMOCK_HEADERS = $(GMOCK_DIR)/include/gmock/*.h \
                $(GMOCK_DIR)/include/gmock/internal/*.h \
                $(GTEST_HEADERS)

###### TARGETS ###############################################
# House-keeping build targets.

all : main $(TESTS)

test : $(TESTS)

clean :
	rm -f $(MAIN_NAME) $(TESTS) gmock.a gmock_main.a *.o

####### BUILD TARGETS ########################################
OBJECTS = Dealer.o

Dealer.o: src/Dealer.cpp include/Dealer.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c src/Dealer.cpp -o $@

# a file containing main()
main.o: src/main.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c src/main.cpp -o $@

main: $(OBJECTS) main.o
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $^ -o $(MAIN_NAME)

####### TEST BUILD TARGETS ###################################
TEST_OBJECTS = test_Order.o test_Commodity.o test_Dealer.o \
			   test_OrderStore.o test_SharedPtr.o \
			   test_CopyIf.o test_Message.o \
			   test_FilledMessage.o test_RevokedMessage.o \
			   test_OrderInfoMessage.o \
			   test_PostConfirmationMessage.o

test_PostConfirmationMessage.o: $(TEST_DIR)/test_PostConfirmationMessage.cpp \
		$(GMOCK_HEADERS) include/PostConfirmationMessage.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(TEST_DIR)/test_PostConfirmationMessage.cpp -o $@

test_OrderInfoMessage.o: $(TEST_DIR)/test_OrderInfoMessage.cpp \
		$(GMOCK_HEADERS) include/OrderInfoMessage.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(TEST_DIR)/test_OrderInfoMessage.cpp -o $@

test_RevokedMessage.o: $(TEST_DIR)/test_RevokedMessage.cpp \
		$(GMOCK_HEADERS) include/RevokedMessage.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(TEST_DIR)/test_RevokedMessage.cpp -o $@

test_FilledMessage.o: $(TEST_DIR)/test_FilledMessage.cpp \
		$(GMOCK_HEADERS) include/FilledMessage.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(TEST_DIR)/test_FilledMessage.cpp -o $@

test_Message.o: $(TEST_DIR)/test_Message.cpp $(GMOCK_HEADERS) \
		include/Message.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(TEST_DIR)/test_Message.cpp -o $@

test_CopyIf.o: $(TEST_DIR)/test_CopyIf.cpp $(GMOCK_HEADERS) \
		include/CopyIf.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(TEST_DIR)/test_CopyIf.cpp -o $@

test_SharedPtr.o: $(TEST_DIR)/test_SharedPtr.cpp $(GMOCK_HEADERS) \
		include/SharedPtr.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(TEST_DIR)/test_SharedPtr.cpp -o $@

test_OrderStore.o: $(TEST_DIR)/test_OrderStore.cpp \
		$(GMOCK_HEADERS) include/Order.h include/exceptions.h \
		include/Commodity.h include/Dealer.h \
		include/SharedPtr.h include/OrderStore.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(TEST_DIR)/test_OrderStore.cpp -o $@


test_Dealer.o: $(TEST_DIR)/test_Dealer.cpp $(GMOCK_HEADERS) \
		include/Dealer.h include/exceptions.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(TEST_DIR)/test_Dealer.cpp -o $@

test_Commodity.o: $(TEST_DIR)/test_Commodity.cpp \
		$(GMOCK_HEADERS) include/Commodity.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(TEST_DIR)/test_Commodity.cpp -o $@

test_Order.o: $(TEST_DIR)/test_Order.cpp $(GMOCK_HEADERS) \
		include/Order.h include/exceptions.h include/Commodity.h \
		include/Dealer.h include/SharedPtr.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(TEST_DIR)/test_Order.cpp -o $@

tests.exe: $(TEST_OBJECTS) $(OBJECTS) gmock_main.a
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@

####### GMOCK-SPECIFIC BUILD TARGETS #########################
# Builds gmock.a and gmock_main.a.  These libraries contain both
# Google Mock and Google Test.  A test should link with either gmock.a
# or gmock_main.a, depending on whether it defines its own main()
# function.  It's fine if your test only uses features from Google
# Test (and not Google Mock).

# Usually you shouldn't tweak such internal variables, indicated by a
# trailing _.
GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)
GMOCK_SRCS_ = $(GMOCK_DIR)/src/*.cc $(GMOCK_HEADERS)

# For simplicity and to avoid depending on implementation details of
# Google Mock and Google Test, the dependencies specified below are
# conservative and not optimized.  This is fine as Google Mock and
# Google Test compile fast and for ordinary users their source rarely
# changes.
gtest-all.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) -I$(GMOCK_DIR) $(CXXFLAGS) \
            -c $(GTEST_DIR)/src/gtest-all.cc

gmock-all.o : $(GMOCK_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) -I$(GMOCK_DIR) $(CXXFLAGS) \
            -c $(GMOCK_DIR)/src/gmock-all.cc

gmock_main.o : $(GMOCK_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) -I$(GMOCK_DIR) $(CXXFLAGS) \
            -c $(GMOCK_DIR)/src/gmock_main.cc

gmock.a : gmock-all.o gtest-all.o
	$(AR) $(ARFLAGS) $@ $^

gmock_main.a : gmock-all.o gtest-all.o gmock_main.o
	$(AR) $(ARFLAGS) $@ $^


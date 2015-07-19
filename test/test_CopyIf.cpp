#include "gmock/gmock.h"

#include <iterator>
#include <vector>

using namespace testing;
using namespace std;

namespace {
bool isEven(int num) { return num % 2 == 0; }
}

template<
    class InputIterator,
    class OutputIterator,
    class Predicate>
void copy_if(InputIterator first,
             InputIterator last,
             OutputIterator out,
             Predicate pred) {
    for (; first != last; ++first) {
        if (pred(*first)) {
            *out++ = *first;
        }
    }
}

TEST(ACopyIf, CopiesElementsIfTheyMatchAPredicate) {
    int vals[] = {4, 5, 5, 4};

    int evenVals[] = {4, 4};
    vector<int> even;
    copy(evenVals, evenVals + 2, back_inserter(even));

    vector<int> result;

    copy_if(vals, vals + 4, back_inserter(result), isEven);

    ASSERT_THAT(result, Eq(even));
}

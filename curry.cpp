// curry.cpp
// Glenn G. Chappell
// 2024-02-26
//
// For CS 331 Spring 2024
// Currying in C++

#include <iostream>
using std::cout;
using std::endl;
using std::cin;
#include <functional>
using std::function;


// make_multiplier
// Return a function object (a closure) that multiplies by the given k.
function<int(int)> make_multiplier(int k)
{
    auto doit = [=](int x)
    {
        return k * x;
    };

    // Return value is a function object, which wraps the lambda
    // function defined above. This object is a closure; it *captures* a
    // portion of the environment in which it is defined. The "[=]"
    // above means that the closure captures a copy of every variable it
    // uses. Replace this with "[k]" to specify that only a copy of k
    // should be captured. Replace with "[&k]" to capture k by reference
    // -- a very bad idea in this particular case, as k is a local
    // variable of function make_multiplier.

    return doit;
}


// userPause
// Wait for user to press ENTER: read all chars through first newline.
void userPause()
{
    std::cout.flush();
    while (std::cin.get() != '\n') ;
}


// Main program
// Demonstrate make_multiplier without and with currying.
int main()
{
    cout << "Demonstration of Currying in C++" << endl;
    cout << endl;

    auto times2 = make_multiplier(2);

    cout << "Without currying:" << endl;
    cout << "300 times 2 is " << times2(300) << "." << endl;
    cout << endl;

    cout << "Currying:" << endl;
    cout << "300 times 2 is " << make_multiplier(300)(2) << "." << endl;
    cout << endl;

    // Wait for user
    cout << "Press ENTER to quit ";
    userPause();
}


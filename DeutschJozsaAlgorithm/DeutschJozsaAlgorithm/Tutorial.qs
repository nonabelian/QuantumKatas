﻿namespace Quantum.DeutschJozsaAlgorithm
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // "Deutsch-Jozsa algorithm" quantum kata is a series of exercises designed 
    // to get you familiar with programming in Q#.
    // It covers the following topics:
    //  - writing oracles (quantum operations which implement certain classical functions),
    //  - Bernstein-Vazirani algorithm for recovering the parameters of a parity function,
    //  - Deutsch-Jozsa algorithm for recognizing a function as constant or balanced, and
    //  - writing tests in Q#.
    //
    // Each task is wrapped in one operation preceeded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.

    //////////////////////////////////////////////////////////////////
    // Part I. Oracles
    //////////////////////////////////////////////////////////////////

    // Task 1.1. f(x) = 0
    // Inputs: 
    //      1) N qubits in arbitrary state |x〉 (input register)
    //      2) a qubit in arbitrary state |y〉 (output qubit)
    // Goal: transform state |x, y〉 into state |x, y ⊕ f(x)〉 (⊕ is addition modulo 2).
    operation Oracle_Zero (x : Qubit[], y : Qubit) : ()
    {
        body
        {
            // Since f(x) = 0 for all values of x, |y ⊕ f(x)〉 = |y〉.
            // This means that the operation doesn't need to do any transformation to the inputs.
            // Build the project and run the tests to see that T01_Oracle_Zero_Test test passes.
        }
        adjoint auto;
    }

    // Task 1.2. f(x) = 1
    // Inputs: 
    //      1) N qubits in arbitrary state |x〉 (input register)
    //      2) a qubit in arbitrary state |y〉 (output qubit)
    // Goal: transform state |x, y〉 into state |x, y ⊕ f(x)〉 (⊕ is addition modulo 2).
    operation Oracle_One (x : Qubit[], y : Qubit) : ()
    {
        body
        {
            // Since f(x) = 1 for all values of x, |y ⊕ f(x)〉 = |y ⊕ 1〉 = |NOT y〉.
            // This means that the operation needs to flip qubit y (i.e. transform |0〉 to |1〉 and vice versa).

            // ...
        }
        adjoint auto;
    }

    // Task 1.3. f(x) = x_k (the value of k-th qubit)
    // Inputs: 
    //      1) N qubits in arbitrary state |x〉 (input register)
    //      2) a qubit in arbitrary state |y〉 (output qubit)
    //      3) 0-based index of the qubit from input register (0 <= k < N)
    // Goal: transform state |x, y〉 into state |x, y ⊕ x_k〉 (⊕ is addition modulo 2).
    operation Oracle_Kth_Qubit (x : Qubit[], y : Qubit, k : Int) : ()
    {
        body
        {
            // The following line enforces the constraints on the value of k that you are given.
            // You don't need to modify it. Feel free to remove it, this won't cause your code to fail.
            AssertBoolEqual(0 <= k && k < Length(x), true, "k should be between 0 and N-1, inclusive");

            // ...
        }
        adjoint auto;
    }

    // Task 1.4. f(x) = 1 if x has odd number of 1s, and 0 otherwise
    // Inputs: 
    //      1) N qubits in arbitrary state |x〉 (input register)
    //      2) a qubit in arbitrary state |y〉 (output qubit)
    // Goal: transform state |x, y〉 into state |x, y ⊕ f(x)〉 (⊕ is addition modulo 2).
    operation Oracle_OddNumberOfOnes (x : Qubit[], y : Qubit) : ()
    {
        body
        {
            // Hint: f(x) can be represented as x_0 ⊕ x_1 ⊕ ... ⊕ x_(N-1)

            // ...
        }
        adjoint auto;
    }

    // Task 1.5. f(x) = Σᵢ 𝑟ᵢ 𝑥ᵢ modulo 2 for a given bit vector r (parity function)
    // Inputs: 
    //      1) N qubits in arbitrary state |x〉 (input register)
    //      2) a qubit in arbitrary state |y〉 (output qubit)
    //      3) a bit vector of length N represented as Bool[]
    // You are guaranteed that the qubit array and the bit vector have the same length.
    // Goal: transform state |x, y〉 into state |x, y ⊕ f(x)〉 (⊕ is addition modulo 2).
    //
    // Note: the functions featured in tasks 1.1, 1.3 and 1.4 are special cases of parity function.
    operation Oracle_ParityFunction (x : Qubit[], y : Qubit, r : Bool[]) : ()
    {
        body
        {
            // The following line enforces the constraint on the input arrays.
            // You don't need to modify it. Feel free to remove it, this won't cause your code to fail.
            AssertIntEqual(Length(x), Length(r), "Arrays should have the same length");

            // ...
        }
        adjoint auto;
    }

    // Task 1.6. f(x) = Σᵢ (𝑟ᵢ 𝑥ᵢ + (1 - 𝑟ᵢ)(1 - 𝑥ᵢ)) modulo 2 for a given bit vector r
    // Inputs: 
    //      1) N qubits in arbitrary state |x〉 (input register)
    //      2) a qubit in arbitrary state |y〉 (output qubit)
    //      3) a bit vector of length N represented as Bool[]
    // You are guaranteed that the qubit array and the bit vector have the same length.
    // Goal: transform state |x, y〉 into state |x, y ⊕ f(x)〉 (⊕ is addition modulo 2).
    operation Oracle_ProductFunction (x : Qubit[], y : Qubit, r : Bool[]) : ()
    {
        body
        {
            // The following line enforces the constraint on the input arrays.
            // You don't need to modify it. Feel free to remove it, this won't cause your code to fail.
            AssertIntEqual(Length(x), Length(r), "Arrays should have the same length");

            // ...
        }
        adjoint auto;
    }

    // Task 1.7. f(x) = Σᵢ 𝑥ᵢ + (1 if prefix of x is equal to the given bit vector r, and 0 otherwise)
    // Inputs: 
    //      1) N qubits in arbitrary state |x〉 (input register)
    //      2) a qubit in arbitrary state |y〉 (output qubit)
    //      3) a bit vector of length P represented as Bool[] (1 <= P <= N)
    // Goal: transform state |x, y〉 into state |x, y ⊕ f(x)〉 (⊕ is addition modulo 2).
    operation Oracle_HammingWithPrefix (x : Qubit[], y : Qubit, prefix : Bool[]) : ()
    {
        body
        {
            // The following line enforces the constraint on the input arrays.
            // You don't need to modify it. Feel free to remove it, this won't cause your code to fail.
            let P = Length(prefix);
            AssertBoolEqual(1 <= P && P <= Length(x), true, "P should be between 1 and N, inclusive");

            // Hint: the first part of the function is the same as in task 1.4

            // ...
        }
        adjoint auto;
    }

    //////////////////////////////////////////////////////////////////
    // Part II. Bernstein-Vazirani Algorithm
    //////////////////////////////////////////////////////////////////

    // Task 2.1. State preparation for Bernstein-Vazirani algorithm
    // Inputs:
    //      1) N qubits in |0〉 state (query register)
    //      2) a qubit in |0〉 state (answer register)
    // Goal:
    //      1) create an equal superposition of all basis vectors from |0...0〉 to |1...1〉 on query register
    //         (i.e. state (|0...0〉 + ... + |1...1〉) / sqrt(2^N) )
    //      2) create |-〉 state (|-〉 = (|0〉 - |1〉) / sqrt(2)) on answer register
    operation BV_StatePrep (query : Qubit[], answer : Qubit) : ()
    {
        body
        {
            // ...
        }
        adjoint auto;
    }

    // Task 2.2. Bernstein-Vazirani algorithm implementation
    // Inputs:
    //      1) the number of qubits in the input register N for the function f
    //      2) a quantum operation which implements the oracle |x〉|y〉 -> |x〉|y ⊕ f(x)〉, where
    //         x is N-qubit input register, y is 1-qubit answer register, and f is a Boolean function
    // You are guaranteed that the function f implemented by the oracle is a parity function
    // (can be represented as f(𝑥₀, …, 𝑥ₙ₋₁) = Σᵢ 𝑟ᵢ 𝑥ᵢ modulo 2 for some bit vector r = (𝑟₀, …, 𝑟ₙ₋₁)).
    // You have implemented the oracle implementing the parity function in task 1.5.
    // Output:
    //      A bit vector r reconstructed from the function
    operation BV_Algorithm (N : Int, Uf : ((Qubit[], Qubit) => ())) : Bool[]
    {
        body
        {
            // Declare a Bool array in which the result will be stored;
            // the array has to be mutable to allow updating its elements.
            mutable r = new Bool[N];

            // ...

            return r;
        }
    }

    // Task 2.3. Testing Bernstein-Vazirani algorithm
    // Goal: use your implementation of Bernstein-Vazirani algorithm from task 2.2 to figure out 
    // what bit vector the parity function oracle from task 1.5 was using.
    // As a reminder, this oracle creates an operation f(x) = Σᵢ 𝑟ᵢ 𝑥ᵢ modulo 2 for a given bit vector r,
    // and Bernstein-Vazirani algorithm recovers that bit vector given the operation.
    operation BV_Test () : ()
    {
        body
        {
            // Hint: use Oracle_ParityFunction to implement the parity function oracle passed to BV_Algorithm.
            // Since Oracle_ParityFunction takes three arguments (Qubit[], Qubit and Bool[]), 
            // and the operation passed to BV_Algorithm must take two arguments (Qubit[] and Qubit), 
            // you need to use partial application to fix the third argument (a specific value of a bit vector). 
            // 
            // You might want to use something like the following:
            // let oracle = Oracle_ParityFunction(_, _, [...your bit vector here...]);

            // Hint: use AssertBoolArrayEqual function to assert that the return value of BV_Algorithm operation 
            // matches the expected value (i.e. the bit vector passed to Oracle_ParityFunction).

            // BV_Test appears in the list of unit tests for the solution; run it to verify your code.

            // ...
        }
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Deutsch-Jozsa Algorithm
    //////////////////////////////////////////////////////////////////

    // Task 3.1. Deutsch-Jozsa algorithm implementation
    // Inputs:
    //      1) the number of qubits in the input register N for the function f
    //      2) a quantum operation which implements the oracle |x〉|y〉 -> |x〉|y ⊕ f(x)〉, where
    //         x is N-qubit input register, y is 1-qubit answer register, and f is a Boolean function
    // You are guaranteed that the function f implemented by the oracle is either 
    // constant (returns 0 on all inputs or 1 on all inputs) or 
    // balanced (returns 0 on exactly one half of the input domain and 1 on the other half).
    // Output:
    //      true if the function f is constant 
    //      false if the function f is balanced
    operation DJ_Algorithm (N : Int, Uf : ((Qubit[], Qubit) => ())) : Bool
    {
        body
        {
            // Declare Bool variable in which the result will be accumulated;
            // this variable has to be mutable to allow updating it.
            mutable isConstantFunction = true;

            // Hint: even though Deutsch-Jozsa algorithm operates on a wider class of functions
            // than Bernstein-Vazirani (i.e. functions which are not parity functions, such as f(x) = 1), 
            // it can be expressed as running Bernstein-Vazirani algorithm
            // and then post-processing the return value classically

            // ...

            return isConstantFunction;
        }
    }

    // Task 3.2. Testing Deutsch-Jozsa algorithm
    // Goal: use your implementation of Deutsch-Jozsa algorithm from task 2.2 to test 
    // each of the oracles you've implemented in part I for being constant or balanced.
    operation DJ_Test () : ()
    {
        body
        {
            // Hint: you will need to use partial application to test Oracle_Kth_Qubit and Oracle_ParityFunction;
            // see task 2.3 for a description of how to do that.

            // Hint: use AssertBoolEqual function to assert that the return value of DJ_Algorithm operation matches the expected value

            // DJ_Test appears in the list of unit tests for the solution; run it to verify your code.

            // ...
        }
    }

}

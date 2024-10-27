# multi_thread_isolate_example

Implement the Isolate Logic

## Getting Started

To use isolates directly rather than with compute, let's modify the example to create isolates manually. This approach gives more control, especially if you want to send messages between isolates, which is useful for long-running tasks or tasks that need to update progress.

This example demonstrates the use of ReceivePort and Isolate.spawn to perform two concurrent tasks:

Task 1: Download a file (simulated with a delay).
Task 2: Find a number of primes up to a given limit.



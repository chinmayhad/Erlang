# Erlang
## MultiThreaded Peer-To-Peer Communication Application

Given the communication information in a text file, this application creates creates a caller.
This caller is represented by a thread. Caller then makes contact with his list of callees.
Once a callee receives a contact request, it must reply to the original person(caller) to indicate that
they have received the contact request.
Of course, we need a way to demonstrate that all of this has worked properly. To keep track of this,
another process called "Master" will be informed on exhange of messages to and from every entity.

This application can handle 0 to n number of callers and their 0 to n sized list of callees.

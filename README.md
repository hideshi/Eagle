Eagle
=====

# What is eagle
Eagle is in-memory full text search engine written in Elixir language.

# How to use

```
$ elixirc /path/to/lib/eagle.ex
$ iex
Erlang/OTP 17 [erts-6.1] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Interactive Elixir (1.0.5) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Eagle.start_link
{:ok, #PID<0.61.0>}
iex(2)> Eagle.add "title1", "This is a content."
:ok
iex(3)> Eagle.add "title2", "This is another content."
:ok
iex(4)> IO.puts inspect Eagle.search "title1"
["This is a content."]
:ok
iex(5)> IO.puts inspect Eagle.search "another"
["This is another content."]
:ok
iex(6)> IO.puts inspect Eagle.search "This is"
["This is a content.", "This is another content."]
:ok
iex(7)>
```


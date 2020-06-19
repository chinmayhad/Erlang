-module(exchange).
-export([start/0, initiation/0, name/2]).

initiation() ->	
	TimeOut = 10000,
	
	receive 
		{Callee,Caller, TimeStamp, Type}->
			io:format("~p received ~p message from ~p [~p]~n", [Callee, Type, Caller,TimeStamp]),
			initiation();
		{Callee, Caller, TimeStamp} -> 
			io:format("~p received reply message from ~p [~p]~n", [Callee, Caller,TimeStamp]),
			initiation()
	after 
		TimeOut ->
			io:format("~nProcess 'Master' has received no calls for 10 seconds, ending...")
    end.
	
	
	
	
name(X,Map1)->
	io:fwrite(X),
	io:fwrite(" => "),
	io:fwrite("~p~n",[maps:get(X,Map1)]).

start() ->
  io:fwrite("\n\n\n"),
  {ok, L} = file:consult("calls.txt"),
  Map1 = maps:from_list(L),
  Names = maps:keys(Map1),
  
  io:fwrite("** Calls to be made **\n"),
  lists:map(fun(X)->  name(X,Map1) end, Names),
  
  io:fwrite("\n"),
  calling:placeCall(self(), maps:keys(Map1), Map1),
  initiation().

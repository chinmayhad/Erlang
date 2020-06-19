-module(calling).
-export([placeCall/3, create_caller/3, create_receiver/4, createAndExchange/3, listener/2]).
-import(lists,[last/1]).
-import(string,[concat/2]). 
-import(string,[len/1]).
-import(string,[sub_string/3]).


create_receiver(CallerN, Callee, Caller_PID, Master_PID) ->
	TimeOut = 5000,
    receive
		intro ->
			Type = intro,
    		Master_PID ! {Callee,CallerN, Type},
			
			Caller_PID ! {Callee, CallerN},
			create_receiver(CallerN,Callee,Caller_PID,Master_PID)
	after 
		TimeOut -> 
			io:format("Process ~p has received no calls for 5 seconds, ending...~n", [Callee])
    end.


create_caller(CallerN, MasterPID, CalleeList) ->
	TimeOut = 5000,
	lists:map(fun(X)-> 
		Callee_PID = spawn(calling, create_receiver, [CallerN, X, self(), MasterPID]), 
		Callee_PID ! intro end, 
	CalleeList),
	
    receive 
		{Callee, CallerN} -> 
			MasterPID ! {Callee,CallerN},
			create_caller(CallerN,MasterPID,[])
	after 
		TimeOut ->
			io:format("Process ~p has received no calls for 5 seconds, ending...~n", [CallerN])
    end.
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
%-------------------------------------------------------
listener(CallerN, MasterPID)->
	%io:format("Caller:~p~n",[Caller]),
	TimeOut = 5000,
	receive
		{Caller, Callee,intro}->
			io:format(""),
			Type = intro,
			TSValue = last(tuple_to_list(erlang:now())),
			MasterPID ! {Callee, Caller, TSValue, Type},%let master know we received intro
			%timer:sleep(round(timer:seconds(random:uniform()))),
			random:seed(),
			timer:sleep(rand:uniform(100)),
			Caller ! {Caller, Callee, TSValue, reply},%ack to the caller
			listener(CallerN, MasterPID);
			
		{Caller, Callee, TSValue, reply}->
			MasterPID ! {Caller, Callee, TSValue}, %let master know we received ack
			listener(CallerN,MasterPID)%to listen continuously
			
		after 
		TimeOut ->
			io:format("~nProcess ~p has received no calls for 5 seconds, ending...",[CallerN])
	
	end.
	
createAndExchange(MasterPID, Keys, Map)->
	
	lists:map(fun(X)-> 
		register(X, spawn(calling, listener, [X,MasterPID]))
		end,
	Keys),%thread for every key
	
	lists:map(fun(X)-> 
		Values = maps:get(X,Map),
		%for every key, take its values and send them intro messages!
		lists:map(fun(Y)->	Caller = X,	Callee = Y,
			random:seed(),
			timer:sleep(rand:uniform(100)),
			
			Callee ! {Caller,Callee, intro} end, Values)end,
	Keys).

	
placeCall(MasterPID, Keys, Map) ->
	PID = spawn(calling, createAndExchange, [MasterPID, Keys, Map]).
	
	

%--------------------------------------------------
	
	
%placeCall(CallerN, MasterPID, CalleeList) ->
	%PID = spawn(calling, create_caller, [CallerN, MasterPID, CalleeList]).

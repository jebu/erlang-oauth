-module(oauth_http).

-export([get/1, get/2, get/3, post/2, post/3, post/4, response_params/1, response_body/1, response_code/1]).


get(URL) ->
  get(URL, []).
get(URL, Options) ->
  get(URL, [], Options).
get(URL, Headers, Options) ->
  request(get, {URL, Headers}, Options).

post(URL, Data) ->
  post(URL, Data, []).
post(URL, Data, Options) ->
  post(URL, Data, [], Options).
post(URL, Data, Headers, Options) ->
  request(post, {URL, Headers, "application/x-www-form-urlencoded", Data}, Options).

request(Method, {URL, Headers, ContentType, Data}, [lhttpc | Options]) ->
  lhttpc:request(URL, Method, [{"Content-Type", ContentType} | Headers], Data, infinity, Options);
request(Method, Request, Options) ->
  httpc:request(Method, Request, [{autoredirect, false}], Options).

response_params(Response) ->
  oauth_uri:params_from_string(response_body(Response)).

response_body({{_, _, _}, _, Body}) ->
  Body.

response_code({{_, Code, _}, _, _}) ->
  Code.

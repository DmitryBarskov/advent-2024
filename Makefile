lib.ex:
	echo "lib.ex"

Elixir.Lib.beam:
	docker run --rm -v "$$PWD:$$PWD" elixir:alpine sh -c "cd $$PWD && elixirc lib.ex"

%: Elixir.Lib.beam
	echo $@
	docker run --rm -v "$$PWD:$$PWD" elixir:alpine sh -c "cd $$PWD && rm -f Elixir.Day$@.beam && elixirc day$@.ex && elixir -e 'Day$@.main()' < inputs/$@.txt"

iex:
	docker run --rm -it -v "$$PWD:$$PWD" elixir:alpine iex

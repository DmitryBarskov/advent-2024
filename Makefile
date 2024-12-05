Elixir.Lib.beam: lib.ex
	docker run --rm -v "$$PWD:$$PWD" elixir:alpine sh -c "cd $$PWD && elixirc lib.ex"

iex:
	docker run --rm -it -v "$$PWD:$$PWD" elixir:alpine iex

%:
	echo $@
	docker run --rm -v "$$PWD:$$PWD" elixir:alpine sh -c "cd $$PWD && rm -f Elixir.Day$@.beam && elixirc day$@.ex && elixir -e 'Day$@.main()' < inputs/$@.txt"

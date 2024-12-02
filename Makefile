lib.ex:
	echo "lib.ex"

Elixir.Lib.beam:
	docker run --rm -v "$$PWD:$$PWD" elixir:alpine sh -c "cd $$PWD && elixirc lib.ex"

%: Elixir.Lib.beam
	docker run --rm -v "$$PWD:$$PWD" elixir:alpine sh -c "cd $$PWD && elixirc day$@.ex && elixir -e 'Day$@.main()' < inputs/$@.txt"

%:
	docker run --rm -v "$$PWD:$$PWD" elixir:alpine sh -c "cd $$PWD && elixir $@.exs < inputs/$@.txt"

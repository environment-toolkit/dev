-include .env

REPOS = et grid actuator
GIT_URL ?= https://github.com/environment-toolkit

.PHONY: install
install:
	go install github.com/DarthSim/overmind/v2@latest
	go install github.com/atkrad/wait4x/cmd/wait4x@latest
	go install github.com/mitranim/gow@latest

$(REPOS):
	git clone ${GIT_URL}/$@.git

.PHONY: repo
repo: $(REPOS)
	git pull
	for f in $(REPOS); do git -C $$f pull; done

.PHONY: npm
npm:
	for f in $(FRONTEND); do cd $$f; npm i; cd -; done

.PHONY: start
start:
	test -e .overmind.sock && overmind quit || true
	test -e .overmind.sock && rm -f .overmind.sock || true
	overmind start -N

.PHONY: overmind-ignore
overmind-ignore:
	echo "OVERMIND_IGNORED_PROCESSES=et" > .overmind.env

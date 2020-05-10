## Make defaults
.DEFAULT_GOAL = help
# Unify target echoing
PRINT_TARGET = @echo "--> $@"

## Targets
help:  ## Display this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	  | sort \
	  | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[0;32m%-30s\033[0m %s\n", $$1, $$2}'

lint:  ## Run linter checks
	$(PRINT_TARGET)
	@shellcheck --version
	@find "${CURDIR}" -name '*.sh' -print0 | xargs -0 -t -n1 shellcheck --color=always --severity=style

toc:  ## Generate README.md table of contents
	$(PRINT_TARGET)
	@bash -c "$$(curl -fsSL raw.githubusercontent.com/ekalinin/github-markdown-toc/master/gh-md-toc) README.md"

.PHONY: \
	help \
	lint \
	toc

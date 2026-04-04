PROJECT := HockCall.xcodeproj
SCHEME := HockCall
SIMULATOR_NAME := iPhone 13

GREEN := \033[0;32m
RED := \033[0;31m
BLUE := \033[0;34m
BOLD := \033[1m
RESET := \033[0m

.PHONY: format lint test check

format:
	@swift format lint -r . --strict

lint:
	@swiftlint --strict

test:
	@set -o pipefail; \
	if ! xcrun simctl list devices available | grep -Fq "$(SIMULATOR_NAME)"; then \
		echo "error: simulator '$(SIMULATOR_NAME)' is not available" >&2; \
		exit 1; \
	fi; \
	xcodebuild test \
		-project "$(PROJECT)" \
		-scheme "$(SCHEME)" \
		-destination "platform=iOS Simulator,name=$(SIMULATOR_NAME)" \
		2>/dev/null | xcbeautify

check:
	@printf "$(BOLD)$(BLUE)==> Running format$(RESET)\n"; \
	if $(MAKE) --no-print-directory format; then \
		printf "$(GREEN)PASS$(RESET) format\n"; \
	else \
		status=$$?; \
		printf "$(RED)FAIL$(RESET) format (exit $$status)\n"; \
		exit $$status; \
	fi; \
	printf "$(BOLD)$(BLUE)==> Running lint$(RESET)\n"; \
	if $(MAKE) --no-print-directory lint; then \
		printf "$(GREEN)PASS$(RESET) lint\n"; \
	else \
		status=$$?; \
		printf "$(RED)FAIL$(RESET) lint (exit $$status)\n"; \
		exit $$status; \
	fi; \
	printf "$(BOLD)$(BLUE)==> Running test$(RESET)\n"; \
	if $(MAKE) --no-print-directory test; then \
		printf "$(GREEN)PASS$(RESET) test\n"; \
		printf "\n$(BOLD)$(GREEN)Check passed$(RESET)\n"; \
	else \
		status=$$?; \
		printf "$(RED)FAIL$(RESET) test (exit $$status)\n"; \
		exit $$status; \
	fi
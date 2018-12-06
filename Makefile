generate:
	swift package generate-xcodeproj
.PHONY: generate

open: generate
	open *.xcodeproj
.PHONY: open

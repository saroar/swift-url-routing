PLATFORM_IOS = iOS Simulator,name=iPhone 11 Pro
PLATFORM_MACOS = macOS
PLATFORM_TVOS = tvOS Simulator,name=Apple TV 4K (at 1080p)

default: test

benchmarks:
	swift run -c release swift-url-routing-benchmark

test:
	xcodebuild test \
		-scheme URLRouting \
		-destination platform="$(PLATFORM_IOS)"
	xcodebuild test \
		-scheme URLRouting \
		-destination platform="$(PLATFORM_MACOS)"
	xcodebuild test \
		-scheme URLRouting \
		-destination platform="$(PLATFORM_TVOS)"

test-linux:
	docker run \
		--rm \
		-v "$(PWD):$(PWD)" \
		-w "$(PWD)" \
		swift:5.5 \
		bash -c 'make test-swift'

test-swift:
	swift test \
		--enable-test-discovery \
		--parallel

format:
	swift format --in-place --recursive \
		./Package.swift ./Sources ./Tests
	find . -type f -name '*.md' -print0 | xargs -0 perl -pi -e 's/ +$$//'

generate-variadics:
	swift run variadics-generator > Sources/URLRouting/Builders/Variadics.swift

.PHONY: benchmarks format generate-variadics test

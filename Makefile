GATEWAY_BINARY_NAME = gateway
GATEWAY_CMD_PATH = cmd/brigade-github-gateway

GATEWAY_IMG ?= somebody/brigade-github-gateway
TAG ?= edge
OUTPUT_DIR = rootfs

.PHONY: build
build:
	cd $(GATEWAY_CMD_PATH) && \
	go build -o ../../$(OUTPUT_DIR)/$(GATEWAY_BINARY_NAME)

.PHONY: linux
linux:
	$(MAKE) gateway-linux

.PHONY: gateway-linux
gateway-linux:
	cd $(GATEWAY_CMD_PATH) && \
	GOOS=linux go build -o ../$(OUTPUT_DIR)/$(GATEWAY_BINARY_NAME)

.PHONY: docker-build
docker-build: linux
docker-build:
	docker build -f Dockerfile -t $(GATEWAY_IMG):$(TAG) .

.PHONY: test
test:
	go test ./pkg/... ./cmd/...
SERVICE_NAME=helm-demo
VERSION=latest
QUAY_VERSION = "supershal/$(SERVICE_NAME):$(VERSION)"

GOCMD = go
GOBUILD=env CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOCMD) build -v

GO_FILES = ./main.go
OBJ_FILES = $(basename $(GO_FILES))

%: %.go
		$(GOBUILD) $<

build-go: $(OBJ_FILES)

test:
		go test ./...

build: clean test build-go

docker: build
		echo $(VERSION)
		docker build --no-cache -t $(SERVICE_NAME) .
		docker tag $(SERVICE_NAME) $(QUAY_VERSION)

push:
		docker push $(QUAY_VERSION)

clean:
		rm -f $(notdir $(OBJ_FILES))
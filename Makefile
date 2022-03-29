# Copyright 2020 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

COMMONENVVAR=GOOS=$(shell uname -s | tr A-Z a-z)
BUILDENVVAR=CGO_ENABLED=0

# GOPROXYCN indicates using goproxy.cn (if TRUE) especially for update-vendor
GOPROXYCN?=FALSE

.PHONY: all
all: build

.PHONY: build
build: update-vendor
	$(COMMONENVVAR) $(BUILDENVVAR) go build -o bin/toy-scheduler

.PHONY: update-vendor
update-vendor:
	GOPROXYCN=$(GOPROXYCN) hack/update-vendor.sh

.PHONY: clean
clean:
	rm -rf ./bin

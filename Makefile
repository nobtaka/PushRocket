# http://hakobe932.hatenablog.com/entry/2012/01/21/142726#fn1

.PHONY: all build archive testflight 
PROJECT ?= PushRocket.xcworkspace
SIGN ?= iPhone Developer: Nobtaka Nukui (AD7CRNTMXX)
SCHEME ?= PushRocket
MOBILEPROVISION ?= provisionings/$(SCHEME).mobileprovision
DISTRIBUTION_LIST ?= PushRocket Testers
NOTIFY ?= False

all: archive

out:
	mkdir -p $@

build: out
	xcodebuild -workspace '$(PROJECT)' -scheme '$(SCHEME)' -sdk iphoneos7.0 -configuration 'Ad Hoc' install DSTROOT=out

archive: build
	xcrun -sdk iphoneos7.0 PackageApplication 'out/Applications/$(SCHEME).app' -o '$(PWD)/out/$(SCHEME).ipa' --sign '$(SIGN)' --embed '$(MOBILEPROVISION)'

testflight: archive
	curl 'http://testflightapp.com/api/builds.json' \
	  -F 'file=@$(PWD)/out/$(SCHEME).ipa' \
	  -F 'api_token=46a5512854d7342b13fb43bf970b00cc_ODA1MjI' \
	  -F 'team_token=c77f21b4454636ae9d1330871b66b732_MjczMTM0MjAxMy0wOS0xNiAwNjo1NjoyNi41MzA2MzE' \
	  -F 'notes=This build was uploaded via the upload API' \
	  -F 'distribution_lists=$(DISTRIBUTION_LIST)' \
	  -F 'notify=$(NOTIFY)'

clean:
	rm -rf ./out

IMAGE = mrothy/scalafmt-native
.PHONY: image sample

image:
	docker build -t $(IMAGE) .

sample:
	docker run -v "$(PWD)/samples:/src" --rm -it $(IMAGE) --test /src

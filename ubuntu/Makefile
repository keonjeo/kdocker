.PHONY: help ubuntu_16_04_dev ubuntu_16_04_golang_dev ubuntu_16_04_ruby_dev
help:
	@echo
	@echo "帮助文档："
	@echo "  - make help                                        查看可用脚本"
	@echo "  - make ubuntu_16_04_dev                            编译基础镜像[dev]"
	@echo "  - make ubuntu_16_04_golang_dev                     编译基础镜像[golang_dev]"
	@echo "  - make ubuntu_16_04_ruby_dev                       编译基础镜像[ruby_dev]"
	@echo

# 编译基础镜像
ubuntu_16_04_dev: image/ubuntu_16_04_dev
ubuntu_16_04_golang_dev: image/ubuntu_16_04_golang_dev
ubuntu_16_04_ruby_dev: image/ubuntu_16_04_ruby_dev

image/%:
	@echo "building docker image $(@F)"
	cd ./images/$(@F) && docker build -t $(@F) .
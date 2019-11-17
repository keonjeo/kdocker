.PHONY: help ubuntu_16_04_base
help:
	@echo
	@echo "帮助文档："
	@echo "  - make help                                      查看可用脚本"
	@echo "  - make ubuntu_16_04_base                         编译基础镜像[base]"
	@echo "  - make ubuntu_16_04_base_dev                     编译基础镜像[base_dev]"
	@echo

# 编译基础镜像
ubuntu_16_04_base: image/ubuntu_16_04_base
ubuntu_16_04_base_dev: image/ubuntu_16_04_base_dev

image/%:
	@echo "building docker image $(@F)"
	cd ./images/$(@F) && docker build -t $(@F) .
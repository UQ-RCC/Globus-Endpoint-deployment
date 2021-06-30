#!/run/current-system/sw/bin/make -f

.PHONY: all
all:
	@echo "Please 'make stage{1,2,3}'"
	@echo "See README.md"

.PHONY: stage1
stage1:
	ansible-playbook -K -v -i globusinventory -l PrimaryGlobusNode \
		--vault-password-file vault_password_file \
		-t m3_globus_part1 globusnodes.yml

.PHONY: stage2
stage2:
	ansible-playbook -K -v -i globusinventory -l PrimaryGlobusNode \
		--vault-password-file vault_password_file \
		-t m3_globus_part2 globusnodes.yml

.PHONY: stage3
stage3:
	ansible-playbook -K -v -i globusinventory -l SecondaryGlobusNodes \
		--vault-password-file vault_password_file \
		globusnodes.yml

.PHONY: update
update:
	ansible-playbook -K -v -i globusinventory -l PrimaryGlobusNode \
		--vault-password-file vault_password_file \
		-t m3_globus_update globusnodes.yml

##
# Make sure the following have been run on each node:
# $ sudo usermod -a -G gcsweb zane
# $ sudo chmod g+rx /var/log/globus-connect-server/gcs-manager/
##
.PHONY: tail
tail: SHELL:=/usr/bin/env bash
tail:
	tail -f \
		<(ssh pol-grid1-hs.hpc.dc.uq.edu.au -- cat /var/log/globus-connect-server/gcs-manager/gcs.log) \
		<(ssh pol-grid2-hs.hpc.dc.uq.edu.au -- cat /var/log/globus-connect-server/gcs-manager/gcs.log)

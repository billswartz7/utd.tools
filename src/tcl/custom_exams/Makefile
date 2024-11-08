
INSTALL_DIR=${UTDTOOLS}/${UTDTOOLSVERSION}/bin

SCRIPTS = \
	build_exams \
	cleanup_exams \
	constant2xcel \
	db2xcel \
	delete_elearning_txt \
	dump_counts \
	dump_fcounts \
	dump_fields \
	dump_header \
	exam_versions \
	loadsql \
	make_report \
	randomize \
	section_update \
	sendit


install:
	@for script in $(SCRIPTS); do \
	  echo "Installing script $${script} to $(INSTALL_DIR)"; \
	  cp bin/$${script} $(INSTALL_DIR); \
	done;

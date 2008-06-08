#convenient Makefile
#
#targets:
#  make           - builds the text and images
#  make text	  - builds the text only
#  make refcheck  - check \label{} and \ref{} and friends for consistency
#                   Result is in "latex_refs.log"
#  make clean     - removed Latex' auxiliary files and finalpix
#  make cleanpics - remove created pics from subdirs
#  make pics	  - create pics
#  make ps        - create PS file
#  make pdf       - create PDF file
#  make html      - create HTML file
#  make changelog - creates ChangeLog

FILE=user_guide

all: 
	make pics
	latex $(FILE)
	#bibtex $(FILE)
	bibtex $(FILE)1
	bibtex $(FILE)2
	#now loop over Latex files, until stable:
	echo Rerun > $(FILE).log
	while grep Rerun $(FILE).log >/dev/null 2>&1 ; do latex $(FILE).tex ; done
	makeindex $(FILE)

text:
	latex $(FILE)
	bibtex $(FILE)
	#now loop over Latex files, until stable:
	echo Rerun > $(FILE).log
	while grep Rerun $(FILE).log >/dev/null 2>&1 ; do latex $(FILE).tex ; done

#check references:
refcheck:
	@rm -f all
	make | grep "Reference\|Rerun" | sed 's/LaTeX\ Warning:\ Reference\ //' | tr '`' "'" > latex_refs.log
	@rm -f all
	make | grep Citation >> latex_refs.log ; true
	@rm -f all
	make | grep Label | grep multiply >> latex_refs.log ; true
	@echo "Check latex_refs.log:"
	@echo "-------------" ; cat latex_refs.log | sort -u | grep -v Rerun


# check FIXMEs in document
fixme:
	grep -C 2 -n "FIXME" *.tex

#make PostScript:
ps:
	make all
	dvips $(FILE).dvi -o $(FILE).ps

#make PDF:
pdf:
	make all
	dvipdf  $(FILE).dvi

# make pics
pics:
	(cd ./grass_integration_images && make)
#	(cd ./help_and_support_images && make)
	(cd ./images && make)
	(cd ./map_composer_images && make)
	(cd ./plugins_gps_images && make)
	(cd ./working_with_projections_images && make)
	(cd ./working_with_ogc_images && make)
	(cd ./plugins_delimited_text_images && make)
	(cd ./plugins_python_images && make)
	(cd ./mapserver_export_images && make)
	(cd ./creating_applications_images && make)
	(cd ./plugins_decorations_images && make)	
	(cd ./plugins_graticule_creator_images && make)
	(cd ./plugins_georeferencer_images && make)
	(cd ./plugins_grass_module_images && make)
	
# make html
# requires: latex2html oder tex4ht
# http://www.cse.ohio-state.edu/~gurari/TeX4ht/mn.html
html:
	make all
	if [ ! -d $(FILE) ]; then mkdir $(FILE); fi
	latex2html -init_file l2h.conf  -split=+2 -dir $(FILE) -address "\
	&copy; 2005, 2006, 2007 \
	<a href=http://www.qgis.org>QGIS Project</a> \
	<br>Last modified: `/bin/date +%d-%m-%Y`" $(FILE)

clean: cleanpics
	rm -f *.log *.aux $(FILE).dvi *.bbl *.tip *.lox *.blg *.ind \
	*.ilg *.toc *.tof *.lof *.lot *.pdf *.ps *.idx *.brf *.out *~
	rm -rf $(FILE)
	rm -rf ./finalpix
	(cd ./appendices && rm -f *.aux)

cleanpics:
	(cd ./grass_integration_images && make clean)
#	(cd ./help_and_support_images && make clean)
	(cd ./images && make clean)
	(cd ./map_composer_images && make clean)
	(cd ./plugins_gps_images && make clean)
	(cd ./working_with_projections_images && make clean)
	(cd ./plugins_delimited_text_images && make clean)
	(cd ./working_with_ogc_images && make clean)
	(cd ./plugins_python_images && make clean)	
	(cd ./mapserver_export_images && make clean)
	(cd ./creating_applications_images && make clean)
	(cd ./plugins_decorations_images && make clean)	
	(cd ./plugins_graticule_creator_images && make clean)
	(cd ./plugins_georeferencer_images && make clean)
	(cd ./plugins_grass_module_images && make clean)
# Simple makefile to process LaTeX documents.
#
# $@ ... the target of the rule
# $< ... the first dependency
# $? ... all dependencies that are newer than the target
# $^ ... all dependencies (without duplicates)
# $+ ...     - " -        (with duplicates)
# $% ... used for archives
# $* ... used for source and target in generic rules
#       (file name without extension)
# $(xD),$(xF) ... the directory/file part of variable $x, where x stands
#                for @,*,%,<,^,+,?
#
LATEX	= pdflatex
SPELLPRG	= aspell -C -t -d british -p ./aspell_personal.txt -c
MAIN	= D1-1

TEXSRC	= $(shell find . -name [^.]\*.tex)
T2=$(TEXSRC)

.PHONY: all latex clean clubber

all: $(MAIN).pdf

test:
	echo $(TEXSRC)
	echo $(T2)

latex:
	$(LATEX) $(MAIN).tex

$(MAIN).pdf: $(MAIN).tex $(TEXSRC)
	$(LATEX) $(MAIN).tex
	$(LATEX) $(MAIN).tex
	bibtex $(MAIN)
	$(LATEX) $(MAIN).tex
	-svn propset svn:keywords "Revision" $(MAIN).tex

clean:
	echo "Cleaning up ..."
	rm -f $(MAIN).aux
	rm -f *.log

#Remove also all backup-files in the directory
clubber: clean
	rm -f ./*\~
	rm -f *.*.BAK
	rm -f Makefile.BAK


.PHONY: status update commit

status:
	svn status
update:
	svn update
commit:
	svn commit -m "Update by ${USER}"


# some very specific commands to launch edit/view programs
.PHONY: work work2 edit edit2 view view2

work: edit view
work2: edit2 view2 
edit: $(TEXSRC)
	$${PAPER_EDIT_PRG} -geometry $${PAPER_EDIT_GEOMETRY} $^ &

edit2: $(TEXSRC)
	$${PAPER_EDIT_PRG2} -geometry $${PAPER_EDIT_GEOMETRY2} $^ &

#Start xdvi to display the document
view: $(MAIN).pdf
	evince $< &

view2: $(MAIN).pdf
	evince $< &

#Perform spell checking
spell: $(TEXSRC)
	for i in $^; do $(SPELLPRG) $$i; done



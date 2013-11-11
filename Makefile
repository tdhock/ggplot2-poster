HOCKING-ggplot2-poster.pdf: HOCKING-ggplot2-poster.tex 
	pdflatex HOCKING-ggplot2-poster
HOCKING-ggplot2-poster.tex: HOCKING-ggplot2-poster.Rnw signals.RData
	echo 'library(knitr);knit("HOCKING-ggplot2-poster.Rnw")'|R --no-save
same-panel.tex: plots.R signals.RData
	R --no-save < $<
signals.RData: signals.R
	R --no-save < $<
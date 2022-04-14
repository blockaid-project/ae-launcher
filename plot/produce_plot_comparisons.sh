#!/usr/bin/env bash
set -e

mkdir -p /data
cd /data

/app/experiments/plot/plot_fetch_pdf.R ./experiments
/app/experiments/plot/make_plt_table.py ./experiments --no-siunitx > /data/plt_table.tex

pdflatex /app/plot/all_plots.tex

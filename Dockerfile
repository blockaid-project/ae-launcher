FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential r-base libcairo2-dev texlive ssh rsync git nano
RUN apt-get install -y --no-install-recommends python3-dev python3-pip

WORKDIR /app
COPY requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt

RUN Rscript -e "install.packages(c('argparse', 'tidyr', 'dplyr', 'ggplot2', 'tikzDevice'))"

COPY . .

EXPOSE 8000

CMD ["/bin/bash"]

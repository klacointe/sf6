# Serves the static site with nginx: docker build -t sf6 . && docker run --rm -p 8080:80 sf6
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
COPY data/ /usr/share/nginx/html/data/
EXPOSE 80

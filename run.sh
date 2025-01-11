docker rmi demo-flask-app --force
docker build -t demo-flask-app . --no-cache #--progress=plain
docker rm demo-flask-app
docker run --name demo-flask-app demo-flask-app
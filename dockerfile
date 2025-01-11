# Ref - https://gist.github.com/soof-golan/6ebb97a792ccd87816c0bda1e6e8b8c2

FROM python:3.12 as python-base

# https://python-poetry.org/docs#ci-recommendations
ENV POETRY_VERSION=1.2.0
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VENV=/opt/poetry-venv

# Tell Poetry where to place its cache and virtual environment
ENV POETRY_CACHE_DIR=/opt/.cache

# Create stage for Poetry installation
FROM python-base as poetry-base

# Creating a virtual environment just for poetry and install it with pip
RUN python3 -m venv $POETRY_VENV \
  && $POETRY_VENV/bin/pip install -U pip setuptools \
  && $POETRY_VENV/bin/pip install poetry 

# Create a new stage from the base python image
FROM python-base as demo-flask-app

# Copy Poetry to app image
COPY --from=poetry-base ${POETRY_VENV} ${POETRY_VENV}

# Add Poetry to PATH
ENV PATH="${PATH}:${POETRY_VENV}/bin"

WORKDIR /app

# Copy Dependencies
COPY poetry.lock pyproject.toml README.md ./

RUN poetry config virtualenvs.path --unset
RUN poetry config virtualenvs.in-project true  --local

# [OPTIONAL] Validate the project is properly configured
RUN poetry check  

# Install Dependencies
RUN poetry install --no-interaction --no-cache
# RUN poetry install --no-interaction --no-cache --without dev

# Copy Application
COPY demo_flask_app .

RUN ls -lah

# Run Application
EXPOSE 5000
CMD [ "poetry", "run", "python", "-m", "flask", "run", "--host=0.0.0.0" ]
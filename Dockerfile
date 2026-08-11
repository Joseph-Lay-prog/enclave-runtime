FROM python:3.12-slim
RUN apt-get update \
    && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir \
       "git+https://github.com/LumenLabs-io/enclave-subnet@7fc22760c3e309331eefbead39df70b85f33ebc1" \
    && apt-get purge -y git && apt-get autoremove -y
COPY agent.py /app/agent.py
USER 65534:65534
CMD ["python", "/app/agent.py"]

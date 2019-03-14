# maxmind-geoip-sidecar [![Docker Repository on Quay](https://quay.io/repository/tenjin/maxmind-geoip-sidecar/status "Docker Repository on Quay")](https://quay.io/repository/tenjin/maxmind-geoip-sidecar)

MaxMind GeoIP Update in Docker for Kubernetes Sidecars

## Usage

Run the image as a initializing sidecar to your workload that needs a fresh MaxMind DB:

```
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: geoip
data:
  GeoIP.conf: |
    UserId 1234567890
    LicenseKey YourLicenseKeyHere
    ProductIds YourProductNameHere

---
# Deployment/StatefulSet/etc...
    spec:
      initContainers:
        - name: maxmind-geoip-sidecar
          image: quay.io/tenjin/maxmind-geoip-sidecar:v4.0.2-alpine3.9
          volumeMounts:
            - name: geoip
              mountPath: /usr/local/etc
            - name: geoip-db
              mountPath: /usr/local/share/GeoIP
      containers:
        - name: myapp
          image: myapp
          volumeMounts:
            - name: geoip-db
              mountPath: /usr/local/share/GeoIP
      volumes:
        - name: geoip
          configMap:
            name: geoip
        - name: geoip-db
          emptyDir: {}
```

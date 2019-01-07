# Fetchmail Container

Derived from https://github.com/cguentherTUChemnitz/docker-fetchmail

To pass in the credentails use environment variables `O365_USER` and `O365_PASS`, e.g.


```
docker run -e O365_USER=username -e O365_PASS=password christopheredsall/gw4-isambard-fetchmail:v0.1 
```

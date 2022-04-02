A dockerfile to build and run [geneweb](https://github.com/geneweb/geneweb)

## run
```shell
docker run --env LANGUAGE=fr --name geneweb -p2317:2317 -v ${pwd}/GenealogyData:/genewebData geneweb:latest
```

## one time init

### database creation

For each family name you want to build a genealogy for, execute:

```shell
docker exec -it geneweb /home/GW/gw/gwc -o /genewebData/lastname.gwb
```
### configuration

Next, put a configuration file next to the `/genewebData/lastname.gwb` bearing the same name: e.g. here `lastname.gwf`

See included `lastname.gwf` for an example.

See `a.gwf` for a full configuration file.

## configuration
### access control
Use `global-access.auth` for a global or per site access
See at the top of `lastanme.gwf` for a read open but write control access

Official doc cf. https://geneweb.tuxfamily.org/wiki/configuration
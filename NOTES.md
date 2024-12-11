
# Installation
- https://www.elastic.co/guide/en/elasticsearch/reference/8.16/docker.html

Load OGR data on elasticsearch
- https://www.elastic.co/blog/how-to-ingest-geospatial-data-into-elasticsearch-with-gdal
- https://gdal.org/en/latest/drivers/vector/elasticsearch.html

``` bash
# Write mapping file
ogr2ogr -lco INDEX_NAME=gdal-data -lco NOT_ANALYZED_FIELDS={ALL} ES:http://localhost:9200 data/sergipe-lito.shp
```

Mapping types
- https://www.elastic.co/jp/blog/found-elasticsearch-mapping-introduction
- https://www.elastic.co/guide/en/elasticsearch/reference/8.4/explicit-mapping.html


  
#!/bin/bash
echo Building for windows...

echo Building PortalApi
cd ../MyPacr.PortalApi
docker build -t mypacr/portalapi .

echo Building PortalFront
cd ../MyPacr.PortalFront
docker build -t mypacr/portalfront .

echo Building Terminal
cd ../MyPacr.Terminal
docker build -t mypacr/terminal .

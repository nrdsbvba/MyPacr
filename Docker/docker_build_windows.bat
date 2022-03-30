@ECHO off
ECHO Building for windows...

ECHO Building PortalApi
cd ../MyPacr.PortalApi
docker build -t mypacr/portalapi .

ECHO Building PortalFront
cd ../MyPacr.PortalFront
docker build -t mypacr/portalfront .

ECHO Building Terminal
cd ../MyPacr.Terminal
docker build -t mypacr/terminal .

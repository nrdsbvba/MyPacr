FROM node as build-stage

ARG smartschool_url="#_#{var_smartschool_url}#_#"
ENV SMARTSCHOOL_URL=$smartschool_url

ARG api_url="#_#{var_portalSettings_apiUrl}#_#"
ENV API_URL=$api_url

ARG portal_front="#_#{var_portalSettings_urlFront}#_#"
ENV API_PORTALFRONT=$portal_front

ARG smartSchoolClientId="#_#{var_smartschool_clientId}#_#"
ENV SMARTSCHOOL_CLIENTID=$smartSchoolClientId


WORKDIR '/app'
COPY ./package.json ./
RUN npm install
COPY . .
RUN npm run build

# production stage
FROM nginx:1.13.12-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html


CMD ["nginx", "-g", "daemon off;"]
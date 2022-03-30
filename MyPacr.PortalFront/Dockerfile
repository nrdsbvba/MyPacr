FROM node:14.2 as build-stage

ARG smartschool_url="#_#{var_smartschool_url}#_#"
ENV SMARTSCHOOL_URL=$smartschool_url

ARG api_url="http://localhost:80/api"
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

EXPOSE 2000

# set app serving to permissive / assigned
ENV NUXT_HOST=0.0.0.0
# set app port
ENV NUXT_PORT=2000

CMD [ "npm", "start" ]

# production stage
#FROM nginx:1.13.12-alpine as production-stage
#COPY --from=build-stage /app/dist /usr/share/nginx/html


#CMD ["nginx", "-g", "daemon off;"]
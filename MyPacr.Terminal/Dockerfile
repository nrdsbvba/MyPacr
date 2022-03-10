FROM node:14.2 as build-stage

ARG directusSettings_url="#_#{var_directusSettings_url}#_#"
ENV DIRECTUS_API_URL=$directusSettings_url

ARG directusSettings_token="#_#{var_directusSettings_token}#_#"
ENV DIRECTUS_API_TOKEN=$directusSettings_token

WORKDIR '/app'
COPY ./package.json ./
RUN npm install
COPY . .
RUN npm run build

# production stage
FROM nginx:1.13.12-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html


CMD ["nginx", "-g", "daemon off;"]
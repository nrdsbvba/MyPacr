FROM node:14.2 as build-stage

ARG directusSettings_url="http://localhost:8055"
ENV DIRECTUS_API_URL=$directusSettings_url

ARG directusSettings_token="4E29pMC5ZdHpW0TmhJubySEs"
ENV DIRECTUS_API_TOKEN=$directusSettings_token

WORKDIR '/app'
COPY ./package.json ./
RUN npm install
COPY . .
RUN npm run build

# expose 5000 on container
EXPOSE 3000

# set app serving to permissive / assigned
ENV NUXT_HOST=0.0.0.0
# set app port
ENV NUXT_PORT=3000

CMD [ "npm", "start" ]

# production stage
#FROM nginx:1.13.12-alpine as production-stage
#COPY --from=build-stage /app/dist /usr/share/nginx/html


#CMD ["nginx", "-g", "daemon off;"]
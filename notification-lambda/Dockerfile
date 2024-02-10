FROM public.ecr.aws/lambda/nodejs:18

COPY . .

RUN npm install --omit=dev

CMD ["app.lambdaHandler"]
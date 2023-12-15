# Use the golang:alpine image as the base image
FROM golang:alpine

# Set the working directory inside the container
WORKDIR /web

# Copy the local code to the container workspace
COPY . .

#Solving GO modules error
RUN go mod init WebApp

# Build the Go application
RUN go build -o dispatcher .

EXPOSE 80

# Command to run the application when the container starts
CMD ["/web/dispatcher"]

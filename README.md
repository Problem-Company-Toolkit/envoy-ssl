# Envoy-SSL Template with Certbot

Welcome to the Envoy-SSL template repository. This template provides an easy setup for integrating Envoy with automatic SSL renewals using Certbot. By using this, you can set up a reliable SSL-secured environment for your applications without the regular overhead of managing certificate renewals.

## Overview

Here's a high-level overview of how this setup works:

1. We utilize Jonasal's `jonasal/nginx-certbot` Docker image to run an automated NGINX+Certbot renewal container.
2. The Envoy and Certbot containers are created, sharing the volume where the certificates will reside.
3. Envoy is set up with a HTTP configuration to route `/.well-known/` paths to the Certbot container. In addition to this, Envoy has an HTTPS configuration designed to work with the secured certificate. This HTTPS setup is what you'll integrate with your application.
4. Once you initiate everything using `docker-compose`, Certbot will communicate with Let's Encrypt's servers to procure the certificates. Once done, Envoy will have access to these certificates, empowering it to serve SSL. Certbot will periodically check for and handle certificate renewals.


We also use Jinja2 templates for replacing variables.

## How should I use this?

The intent behind this project is that you ca clone it then repurpose it to your needs. What makes this most useful is that it comes with a Certbot + Envoy setup which provisions SSL certificates, you just need to give it the right configurations.

With this, you can set this up to provision certificates for most use-cases. This setup only works with the HTTP-01 challenge, so you won't be able to provision wildcard certificates.

## Getting Started

### Prerequisites

Ensure you have Docker and Docker-Compose installed on your system.

### Configuration

We utilize a `.env` file for configuration settings.

Check the `.env` file in this repository for an example and explanations of each of the values that are used by this setup.

Values from the `.env` file are used to replace values in the Envoy configuration files, which use Jinja2.

Also, you can pass any configuration from [Jonas Alfredsson's Nginx-Certbot's documentation](https://github.com/JonasAlfredsson/docker-nginx-certbot) to the Certbot container, since it's the same image. So, you could use a local CA, toggle ECDSA, etc.

### How to Use

The setup below presumes you already have your DNS records pointing to the endpoint you're provisioning the SSL certificates from. For instance, that you have already created an A record that points to the VPS where you're running this.

1. Clone this repository.
2. Modify the `.env` file with your configurations.
3. Navigate to the root directory and run:

   ```
   docker-compose up -d
   ```

4. Once set up, Certbot will request Let's Encrypt for the necessary certificates, and your Envoy proxy will be secured with SSL.

## Conclusion

This template offers an efficient way to set up Envoy with SSL, backed by Certbot for automatic renewals. Feel free to use this as a base for your projects and contribute any improvements or suggestions you may have.

---

Happy coding and stay secure! 🚀